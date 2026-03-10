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

      // Use TRPC createBusiness endpoint: /trpc/createBusiness?batch=1
      final baseWithoutVersion = ApiUrls.baseUrl.replaceAll('/v1', '');
      // baseWithoutVersion already ends with /api, so we append only /trpc/...
      final url = '$baseWithoutVersion/trpc/createBusiness';

      final response = await _client.dio.post(
        url,
        queryParameters: {"batch": "1"},
        data: wrappedPayload,
      );

      final data = response.data;
      if (data is List && data.isNotEmpty) {
        final first = data.first;
        if (first is Map<String, dynamic>) {
          final json = first["result"]?["data"]?["json"];
          if (json is Map<String, dynamic>) {
            final success = json["success"] == true;
            final bookingId = json["business"]?["\$id"]?.toString();
            if (success && bookingId != null && bookingId.isNotEmpty) {
              return Right(bookingId);
            }
            final message = json["message"]?.toString() ?? "Create business failed";
            return Left(RequestFailure(message));
          }
        }
      }

      return Left(RequestFailure("Invalid response from create business"));
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

  /// Updates an existing business using the TRPC updateBusiness endpoint.
  Future<Either<RequestFailure, void>> updateBusinessTrpc(
    String businessId,
    CreateBusinessPayload payload,
  ) async {
    try {
      final baseWithoutVersion = ApiUrls.baseUrl.replaceAll('/v1', '');
      // baseWithoutVersion already ends with /api, so we append only /trpc/...
      final url = '$baseWithoutVersion/trpc/updateBusiness';

      final jsonPayload = payload.toJson();

      // Build meta.values for fields that should be treated as "undefined" by TRPC
      final metaValues = <String, dynamic>{};

      // Website: when empty or null, backend expects data.website: ["undefined"]
      final website = jsonPayload['website'];
      if (website == null || website.toString().isEmpty || website == 'undefined') {
        metaValues['data.website'] = ['undefined'];
        jsonPayload['website'] = null;
      }

      final wrappedPayload = {
        "0": {
          "json": {
            "businessId": businessId,
            "data": jsonPayload,
          },
          "meta": {
            "values": metaValues,
            "v": 1,
          },
        },
      };

      // Optional: log pretty payload for debugging
      try {
        final pretty = const JsonEncoder.withIndent('  ').convert(wrappedPayload);
        // ignore: avoid_print
        print('📤 UpdateBusiness full payload:\n$pretty');
      } catch (_) {}

      final response = await _client.dio.post(
        url,
        queryParameters: {"batch": "1"},
        data: wrappedPayload,
      );

      final data = response.data;
      if (data is List && data.isNotEmpty) {
        final first = data.first;
        if (first is Map<String, dynamic>) {
          final json = first["result"]?["data"]?["json"];
          if (json is Map<String, dynamic>) {
            final success = json["success"] == true;
            final message = json["message"]?.toString() ?? "Update failed";
            if (success) {
              return const Right(null);
            }
            return Left(RequestFailure(message));
          }
        }
      }

      return Left(RequestFailure("Invalid response from update business"));
    } on DioException catch (e) {
      final message =
          e.response?.data?["message"] ?? e.message ?? "Failed to update business";
      return Left(RequestFailure(message));
    } catch (e) {
      return Left(RequestFailure(e.toString()));
    }
  }

  /// Fetches bookings for a specific business using the TRPC listBusinessBookings endpoint.
  Future<Either<RequestFailure, BookingListResponse>> getBusinessBookingsTrpc({
    required String businessId,
    List<String>? statuses,
    int? limitAll,
    int? limitFiltered,
  }) async {
    try {
      final baseWithoutVersion = ApiUrls.baseUrl.replaceAll('/v1', '');
      // baseWithoutVersion already ends with /api, so we append only /trpc/...
      final url = '$baseWithoutVersion/trpc/listBusinessBookings,listBusinessBookings';

      final input = <String, dynamic>{
        "0": {
          "json": {
            "businessId": businessId,
            if (limitAll != null) "limit": limitAll,
          },
        },
        "1": {
          "json": {
            "businessId": businessId,
            if (statuses != null && statuses.isNotEmpty) "status": statuses,
            if (limitFiltered != null) "limit": limitFiltered,
          },
        },
      };

      final response = await _client.dio.get(
        url,
        queryParameters: {
          "batch": "1",
          "input": jsonEncode(input),
        },
      );

      final data = response.data;
      if (data is! List || data.isEmpty) {
        return Left(RequestFailure("Invalid business bookings response"));
      }

      // Use the second entry (filtered list) by default if present; fall back to first.
      final Map<String, dynamic>? entry = (data.length > 1 ? data[1] : data[0]) as Map<String, dynamic>?;
      if (entry == null) {
        return Left(RequestFailure("Malformed business bookings response"));
      }

      final json = entry["result"]?["data"]?["json"];
      if (json is! Map<String, dynamic>) {
        return Left(RequestFailure("Invalid business bookings payload"));
      }

      final result = BookingListResponse.fromJson(json);
      return Right(result);
    } on DioException catch (e) {
      final message = e.response?.data?["message"] ?? e.message ?? "Failed to load business bookings";
      return Left(RequestFailure(message));
    } catch (e) {
      return Left(RequestFailure(e.toString()));
    }
  }

  Future<Either<RequestFailure, void>> cancelBooking(String bookingId, {String reason = ''}) async {
    try {
      // TRPC payload structure as provided by user
      final payload = {
        "0": {
          "json": {
            "bookingId": bookingId,
            "action": "user_cancel",
            "reason": reason,
          },
        },
      };

      final baseWithoutVersion = ApiUrls.baseUrl.replaceAll('/v1', '');
      // baseWithoutVersion already ends with /api, so we append only /trpc/...
      final url = '$baseWithoutVersion/trpc/updateBookingStatus';

      final response = await _client.dio.post(
        url,
        queryParameters: {"batch": "1"},
        data: payload,
      );

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
            final message = json["message"]?.toString() ?? "Cancel booking failed";
            return Left(RequestFailure(message));
          }
        }
      }

      return Left(RequestFailure("Invalid response from cancel booking"));
    } on DioException catch (e) {
      final message =
          e.response?.data?["message"] ?? e.message ?? "Failed to cancel booking";
      return Left(RequestFailure(message));
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
