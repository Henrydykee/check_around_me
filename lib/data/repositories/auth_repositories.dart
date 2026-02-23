


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










}