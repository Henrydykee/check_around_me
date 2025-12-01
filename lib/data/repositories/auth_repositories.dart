


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

  Future<Either<RequestFailure, String>> register(CreateAccountModel create) async {
    try {
      final response = await _client.post(ApiUrls.register, data: create.toJson());
      final result = response.data;
      final data = response.data;
      final user = data["data"]?["user"];
      if (user != null) {
        await inject<LocalStorageService>().setJson("user", user);
      }

      // ✅ Extract the access token safely
      final accessToken = response.data["data"]?["accessToken"];
      if (accessToken != null) {
        await inject<LocalStorageService>().setString("token", accessToken);
      }

      return Right(result);
    } on DioException catch (e) {
      return Left(RequestFailure(e.response?.data?["message"] ?? e.message ?? "Unknown network error"));
    } catch (e) {
      return Left(RequestFailure("Unexpected error occurred: $e"));
    }
  }


  Future<Either<RequestFailure, String>> login({required String email, required String password}) async {
    try {
      final response = await _client.post(ApiUrls.login, data: {"email": email, "password": password});

      final data = response.data;
      final result = data.toString();
      final accessToken = data["data"]?["accessToken"];
      if (accessToken != null) {
        await inject<LocalStorageService>().setString("token", accessToken);
      } else {
        return Left(RequestFailure("Access token not found in response"));
      }
      final user = data["data"]?["user"];
      if (user != null) {
        await inject<LocalStorageService>().setJson("user", user);
      }
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

  Future<Either<RequestFailure, String>> getCurrentUser() async {
    try {
      final response = await _client.get(ApiUrls.getCurrentUser);
      final data = response.data;
      final result = data.toString();
      return Right(result);
    } catch (e) {
      return Left(RequestFailure(e.toString()));
    }
  }






}