


import 'package:check_around_me/data/model/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

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
      inject<LocalStorageService>().setString("secret", secret);
      final result = data.toString();
      return Right(result);
    } on DioException catch (e) {
      final errorMsg = e.response?.data?["message"] ?? e.message ?? "Network error occurred";
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
    } catch (e, stack) {
      return Left(RequestFailure(e.toString()));
    }
  }









}