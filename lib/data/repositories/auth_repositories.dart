


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