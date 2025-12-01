import 'package:dartz/dartz.dart';

import '../../core/services/api_client.dart';
import '../../core/services/api_urls.dart';
import '../../core/services/request_failure.dart';
import '../model/business_details_response.dart';
import '../model/category_response.dart';
import '../model/create_booking_payload.dart';
import '../model/create_business_payload.dart';

class BusinessRepository {
  final ApiClient _client;
  BusinessRepository(this._client);

  Future<Either<RequestFailure, List<String>>> getBusinesses() async {
    try {
      final response = await _client.get(ApiUrls.listBusinesses);
      final result = response.data;
      return Right(result);
    } catch (e) {
      return Left(RequestFailure(e.toString()));
    }
  }

  Future<Either<RequestFailure, BusinessDetailsResponse>> getBusinessById(String businessId) async {
    try {
      final response = await _client.get(ApiUrls.getBusinessById(businessId));
      final result = BusinessDetailsResponse.fromJson(response.data);
      return Right(result);
    } catch (e) {
      return Left(RequestFailure(e.toString()));
    }
  }

  Future<Either<RequestFailure, String>> createBusiness(CreateBusinessPayload payload) async {
    try {
      final response = await _client.post(ApiUrls.createBusiness, data: payload.toJson());
      final result = response.data;
      return Right(result);
    } catch (e) {
      return Left(RequestFailure(e.toString()));
    }
  }

  Future<Either<RequestFailure, List<BusinessDetailsResponse>>> getMyBusinesses() async {
    try {
      final response = await _client.get(ApiUrls.createBusiness);
      final result = response.data.map((e) => BusinessDetailsResponse.fromJson(e)).toList();
      return Right(result);
    } catch (e) {
      return Left(RequestFailure(e.toString()));
    }
  }

  Future<Either<RequestFailure, List<CatergoryResponse>>> getCategories() async {
    try {
      final response = await _client.get(ApiUrls.getAllCategories);
      final result = response.data.map((e) => CatergoryResponse.fromJson(e)).toList();
      return Right(result);
    } catch (e) {
      return Left(RequestFailure(e.toString()));
    }
  }

  Future<Either<RequestFailure, String>> createBooking(CreateBookingPayload payload) async {
    try {
      final response = await _client.post(ApiUrls.createBooking, data: payload.toJson());
      final result = response.data;
      return Right(result);
    } catch (e) {
      return Left(RequestFailure(e.toString()));
    }
  }
}
