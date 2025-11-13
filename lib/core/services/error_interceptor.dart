
import 'package:dio/dio.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String message;

    print("🔴 [RESPONSE] ${err.requestOptions.method} ${err.requestOptions.uri}");
    print("🔴 Status: ${err.response?.statusCode}");
    print("🔴 Data: ${err.response?.data}");

    if (err.type == DioExceptionType.connectionTimeout) {
      message = "Connection timed out. Please check your internet.";
    } else if (err.type == DioExceptionType.receiveTimeout) {
      message = "Server took too long to respond.";
    } else if (err.type == DioExceptionType.badResponse) {
      final statusCode = err.response?.statusCode ?? 0;
      final responseData = err.response?.data;

      if (responseData is Map && responseData.containsKey("message")) {
        message = responseData["message"];
      } else {
        message = "Server error ($statusCode)";
      }
    } else {
      message = "Something went wrong. Please try again.";
    }

    // Return a clean custom exception
    handler.next(
      DioException(
        requestOptions: err.requestOptions,
        error: message, // 👈 pass only the message
        response: err.response,
      ),
    );
  }
}

