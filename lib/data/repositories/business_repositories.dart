import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/services/api_client.dart';
import '../../core/services/api_urls.dart';
import '../../core/services/request_failure.dart';
import '../model/business_details_response.dart';
import '../model/business_model.dart';
import '../model/category_response.dart';
import '../model/popular_category_response.dart';
import '../model/create_booking_payload.dart';
import '../model/create_business_payload.dart';
import '../model/booking_list_response.dart';
import '../model/create_review_payload.dart';
import '../model/review_model.dart';

class BusinessRepository {
  final ApiClient _client;
  BusinessRepository(this._client);

  Future<Either<RequestFailure, List<BusinessModel>>> getBusinesses() async {
    try {
      final response = await _client.get(ApiUrls.listBusinesses);

      // Make sure the response is decoded JSON
      final data = response.data is String ? jsonDecode(response.data) : response.data;

      final List businessList = data['businesses'] as List;

      final result = businessList
          .map((e) => BusinessModel.fromJson(e as Map<String, dynamic>))
          .toList();

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
      // Wrap payload in the required format
      final jsonPayload = payload.toJson();
      
      // Handle referralCode - set to null if undefined/empty
      final referralCode = jsonPayload['referralCode'];
      final metaValues = <String, dynamic>{};
      if (referralCode == null || referralCode == 'undefined' || referralCode.toString().isEmpty) {
        metaValues['referralCode'] = ['undefined'];
        jsonPayload['referralCode'] = null;
      }
      
      // Wrap in the required structure
      final wrappedPayload = {
        "0": {
          "json": jsonPayload,
          "meta": {
            "values": metaValues,
            "v": 1
          }
        }
      };

      // Log full payload (pretty-printed)
      try {
        final pretty = const JsonEncoder.withIndent('  ').convert(wrappedPayload);
        print('📤 CreateBusiness full payload:\n$pretty');
      } catch (_) {}

      final response = await _client.post(ApiUrls.createBusiness, data: wrappedPayload);
      final result = response.data;
      return Right(result);
    } catch (e) {
      return Left(RequestFailure(e.toString()));
    }
  }

  Future<Either<RequestFailure, List<BusinessDetailsResponse>>> getMyBusinesses() async {
    try {
      final response = await _client.get(ApiUrls.listMyBusinesses);
      final data = response.data is String ? jsonDecode(response.data) : response.data;

      // 200 with null or non-List body = no businesses (empty list)
      if (data == null) {
        return const Right([]);
      }
      if (data is! List) {
        return const Right([]);
      }

      final result = data
          .map((e) => BusinessDetailsResponse.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(result);
    } catch (e) {
      return Left(RequestFailure(e.toString()));
    }
  }

  Future<Either<RequestFailure, List<CategoryResponse>>> getCategories() async {
    try {
      final response = await _client.get(ApiUrls.getAllCategories);
      final rawData = response.data;
      final decoded = rawData is String ? jsonDecode(rawData) : rawData;

      final List dataList = decoded as List;
      final result = dataList.map((e) => CategoryResponse.fromJson(e as Map<String, dynamic>)).toList();

      return Right(result);
    } catch (e) {
      return Left(RequestFailure(e.toString()));
    }
  }

  Future<Either<RequestFailure, List<PopularCategoryResponse>>> getPopularCategories() async {
    try {
      final response = await _client.get(ApiUrls.getPopularCategories);
      final rawData = response.data;
      final decoded = rawData is String ? jsonDecode(rawData) : rawData;

      final List dataList = decoded as List;
      final result = dataList
          .map((e) => PopularCategoryResponse.fromJson(e as Map<String, dynamic>))
          .toList();

      return Right(result);
    } catch (e) {
      return Left(RequestFailure(e.toString()));
    }
  }

  Future<Either<RequestFailure, ReviewsResponse>> getBusinessReviews(String businessId) async {
    try {
      final response = await _client.get(ApiUrls.getBusinessReviews(businessId));
      final data = response.data is String ? jsonDecode(response.data) : response.data;
      if (data is! Map<String, dynamic>) {
        return Left(RequestFailure("Invalid response format"));
      }
      return Right(ReviewsResponse.fromJson(data));
    } catch (e) {
      return Left(RequestFailure(e.toString()));
    }
  }

  Future<Either<RequestFailure, void>> createReview(CreateReviewPayload payload) async {
    try {
      await _client.post(ApiUrls.createReview, data: payload.toJson());
      return const Right(null);
    } catch (e) {
      return Left(RequestFailure(e.toString()));
    }
  }



  Future<Either<RequestFailure, String>> createBooking(CreateBookingPayload payload) async {
    try {
      final response = await _client.post(ApiUrls.createBooking, data: payload.toJson());
      if (response.data is! Map<String, dynamic>) {
        return Left(RequestFailure("Invalid response format"));
      }
      final Map<String, dynamic> data = response.data;
      final bookingJson = data["booking"];
      if (bookingJson == null || bookingJson is! Map<String, dynamic>) {
        return Left(RequestFailure("Booking data not found in response"));
      }
      final bookingId = bookingJson["\$id"] as String?;
      if (bookingId == null || bookingId.isEmpty) {
        return Left(RequestFailure("Booking ID not found"));
      }

      return Right(bookingId);
    } catch (e) {
      return Left(RequestFailure(e.toString()));
    }
  }

  Future<Either<RequestFailure, BookingListResponse>> getMyBookings() async {
    try {
      final response = await _client.get(ApiUrls.listMyBookings);
      
      // Make sure the response is decoded JSON
      final data = response.data is String ? jsonDecode(response.data) : response.data;
      
      if (data is! Map<String, dynamic>) {
        return Left(RequestFailure("Invalid response format"));
      }
      
      final result = BookingListResponse.fromJson(data);
      return Right(result);
    } catch (e) {
      return Left(RequestFailure(e.toString()));
    }
  }

  Future<Either<RequestFailure, void>> cancelBooking(String bookingId, {String reason = ''}) async {
    try {
      // Payload structure as provided by user
      final payload = {
        "0": {
          "json": {
            "bookingId": bookingId,
            "action": "user_cancel",
            "reason": reason
          }
        }
      };
      
      await _client.post(ApiUrls.updateBookingStatusLegacy, data: payload);
      return const Right(null);
    } catch (e) {
      return Left(RequestFailure(e.toString()));
    }
  }

  Future<Either<RequestFailure, List<Images>>> uploadImages(File imageFile, String userID) async {
    try {
      // Get filename from file path
      final fileName = imageFile.path.split('/').last;
      
      // Create multipart form data
      final formData = FormData.fromMap({
        'images': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
        'userID': userID,
      });

      // Make the request with multipart/form-data content type
      final response = await _client.dio.post(
        ApiUrls.uploadImages,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      // Parse response - API returns a List directly
      final data = response.data is String ? jsonDecode(response.data) : response.data;
      
      if (data is! List) {
        return Left(RequestFailure("Invalid response format: expected List"));
      }

      final List<Images> images = data
          .map((e) => Images.fromJson(e as Map<String, dynamic>))
          .toList();

      return Right(images);
    } catch (e) {
      return Left(RequestFailure(e.toString()));
    }
  }

}
