


import 'dart:convert';

import 'package:check_around_me/data/model/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/services/api_client.dart';
import '../../core/services/api_urls.dart';
import '../../core/services/local_storage.dart';
import '../../core/services/request_failure.dart';
import '../../core/vm/provider_initilizers.dart';
import '../model/create_account_payload.dart';

class AuthRepository {
  final ApiClient _client;
  AuthRepository(this._client);

  Future<Either<RequestFailure, bool>> register(CreateAccountModel create) async {
    try {
      final response = await _client.post(ApiUrls.register, data: create.toJson());

      final data = response.data;

      // Extract the boolean safely
      final success = data["success"] == true;

      return Right(success);
    } on DioException catch (e) {
      return Left(
        RequestFailure(
          e.response?.data?["message"] ?? e.message ?? "Unknown network error",
        ),
      );
    } catch (e) {
      return Left(RequestFailure("Unexpected error occurred: $e"));
    }
  }



  Future<Either<RequestFailure, String>> login({required String email, required String password}) async {
    try {
      final response = await _client.post(ApiUrls.login, data: {"email": email, "password": password});
      final data = response.data;
      String secret = data["secret"];
      final storage = inject<LocalStorageService>();
      await storage.setString("secret", secret);
      await storage.setString("savedUserEmail", email);
      final result = data.toString();
      return Right(result);
    } on DioException catch (e) {
      final errorMsg = e.response?.data?["message"] ?? e.message ?? "Network error occurred";
      return Left(RequestFailure(errorMsg));
    } catch (e) {
      return Left(RequestFailure("Unexpected error occurred: $e"));
    }
  }

  /// Login or sign up with Google. Backend creates account if needed and returns same { "secret": "..." } as login.
  Future<Either<RequestFailure, String>> loginWithGoogle({
    required String email,
    required String name,
    required String appwriteUserId,
  }) async {
    try {
      final response = await _client.post(ApiUrls.loginGoogle, data: {
        "email": email,
        "name": name,
        "appwriteUserId": appwriteUserId,
      });
      final data = response.data as Map<String, dynamic>;
      final secret = data["secret"] as String?;
      if (secret == null || secret.isEmpty) {
        return Left(RequestFailure("Invalid response: missing secret"));
      }
      final storage = inject<LocalStorageService>();
      await storage.setString("secret", secret);
      await storage.setString("savedUserEmail", email);
      return Right(secret);
    } on DioException catch (e) {
      final errorMsg = e.response?.data?["message"] ?? e.message ?? "Google sign-in failed";
      return Left(RequestFailure(errorMsg));
    } catch (e) {
      return Left(RequestFailure("Unexpected error occurred: $e"));
    }
  }

  Future<Either<RequestFailure, String>> forgotPassword(String email) async {
    try {
      final response = await _client.post(ApiUrls.requestPasswordReset, data: {"email": email});
      final data = response;
      final result = data.toString();
      return Right(result);
    } catch (e) {
      return Left(RequestFailure(e.toString()));
    }
  }

  Future<Either<RequestFailure, UserModel>> getCurrentUser() async {
    try {
      final response = await _client.get(ApiUrls.getCurrentUser);

      if (response.data is! Map<String, dynamic>) {
        return Left(RequestFailure("Invalid response format"));
      }

      final Map<String, dynamic> data = response.data;
      final userJson = data["user"];

      if (userJson == null || userJson is! Map<String, dynamic>) {
        return Left(RequestFailure("User data not found in response"));
      }

      final user = UserModel.fromJson(userJson);

      await inject<LocalStorageService>().setJson("user", user.toJson());

      await inject<LocalStorageService>().setString("userId", user.id.toString());

      return Right(user);
    } catch (e) {
      return Left(RequestFailure(e.toString()));
    }
  }

  Future<Either<RequestFailure, void>> logout() async {
    try {
      await _client.post(ApiUrls.logout);
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        RequestFailure(
          e.response?.data?["message"] ?? e.message ?? "Logout failed",
        ),
      );
    } catch (e) {
      return Left(RequestFailure(e.toString()));
    }
  }

  Future<Either<RequestFailure, UserModel>> updateUser({
    required String fullName,
    required String phone,
    String? avatarUrl,
    String? referralCode,
  }) async {
    try {
      final payload = <String, dynamic>{
        "fullName": fullName,
        "phone": phone,
        "referralCode": referralCode ?? "",
        "bankDetails": {
          "bankName": "",
          "accountNumber": "",
          "accountName": "",
          "bankCode": "",
          "recipientCode": "",
        },
      };

      if (avatarUrl != null && avatarUrl.isNotEmpty) {
        payload["avatarUrl"] = avatarUrl;
      }

      final response = await _client.patch(ApiUrls.updateUser, data: payload);

      // Check if update was successful (status 200-299)
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        // After successful update, fetch the complete user data
        return await getCurrentUser();
      } else {
        return Left(RequestFailure("Update failed with status: ${response.statusCode}"));
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data?["message"] ?? e.message ?? "Network error occurred";
      return Left(RequestFailure(errorMsg));
    } catch (e) {
      return Left(RequestFailure("Unexpected error occurred: $e"));
    }
  }
  
  /// Changes the user's password using TRPC changePassword endpoint.
  Future<Either<RequestFailure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    try {
      final baseWithoutVersion = ApiUrls.baseUrl.replaceAll('/v1', '');
      // baseWithoutVersion already ends with /api, so we append only /trpc/...
      final url = '$baseWithoutVersion/trpc/changePassword';

      // Matches the browser payload shape for changePassword
      final payload = {
        "0": {
          "json": {
            "currentPassword": currentPassword,
            "newPassword": newPassword,
            "confirmNewPassword": confirmNewPassword,
          },
        },
      };

      final response = await _client.dio.post(url,
          queryParameters: {"batch": "1"}, data: payload);

      final data = response.data;
      if (data is List && data.isNotEmpty) {
        final first = data.first;
        if (first is Map<String, dynamic>) {
          final json = first["result"]?["data"]?["json"];
          if (json is Map<String, dynamic>) {
            final success = json["success"] == true;
            if (success) {
              return const Right(null);
            }
            final message = json["message"]?.toString() ?? "Password change failed";
            return Left(RequestFailure(message));
          }
        }
      }

      return Left(RequestFailure("Invalid response from password change"));
    } on DioException catch (e) {
      final errorMsg = e.response?.data?["message"] ?? e.message ?? "Failed to change password";
      return Left(RequestFailure(errorMsg));
    } catch (e) {
      return Left(RequestFailure("Unexpected error occurred: $e"));
    }
  }
  
  /// Loads referral summary via TRPC and returns the current referral code.
  Future<Either<RequestFailure, String>> getReferralCodeFromSummary() async {
    try {
      final baseWithoutVersion = ApiUrls.baseUrl.replaceAll('/v1', '');
      // baseWithoutVersion already ends with /api, so we append only /trpc/...
      final url = '$baseWithoutVersion/trpc/getReferralSummary,getUserBankDetails';

      // Matches the captured browser request: both inputs with json: null + meta.values: ["undefined"]
      final trpcInput = jsonEncode({
        "0": {
          "json": null,
          "meta": {
            "values": ["undefined"],
            "v": 1,
          },
        },
        "1": {
          "json": null,
          "meta": {
            "values": ["undefined"],
            "v": 1,
          },
        },
      });

      final response = await _client.dio.get(
        url,
        queryParameters: {
          "batch": "1",
          "input": trpcInput,
        },
      );

      final data = response.data;

      if (data is! List || data.isEmpty) {
        return Left(RequestFailure("Invalid referral summary response"));
      }

      final first = data.first;
      if (first is! Map<String, dynamic>) {
        return Left(RequestFailure("Invalid referral summary format"));
      }

      final referralCode = first["result"]?["data"]?["json"]?["referralCode"];
      if (referralCode is String && referralCode.isNotEmpty) {
        return Right(referralCode);
      }

      return Left(RequestFailure("Referral code not found"));
    } on DioException catch (e) {
      final errorMsg = e.response?.data?["message"] ?? e.message ?? "Failed to load referral code";
      return Left(RequestFailure(errorMsg));
    } catch (e) {
      return Left(RequestFailure("Unexpected error occurred: $e"));
    }
  }
}