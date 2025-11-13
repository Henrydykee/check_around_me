import 'package:dio/dio.dart';
import '../vm/provider_initilizers.dart';
import 'api_urls.dart';
import 'error_interceptor.dart';
import 'local_storage.dart';

class ApiClient {
  late final Dio _dio;
  final LocalStorageService _storage = inject<LocalStorageService>();

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiUrls.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      ),
    );

    _dio.interceptors.addAll([
      _AuthInterceptor(_storage),
      // LogInterceptor(
      //   request: true,
      //   requestBody: true,
      //   responseBody: true,
      //   error: true,
      // ),
      ErrorInterceptor(),
    ]);
  }

  Dio get dio => _dio;

  Future<Response<T>> get<T>(
      String path, {
        Map<String, dynamic>? queryParams,
        Options? options,
      }) async {
    return _dio.get<T>(path, queryParameters: queryParams, options: options);
  }

  Future<Response<T>> post<T>(
      String path, {
        dynamic data,
        Options? options,
      }) async {
    return _dio.post<T>(path, data: data, options: options);
  }

  Future<Response<T>> put<T>(
      String path, {
        dynamic data,
        Options? options,
      }) async {
    return _dio.put<T>(path, data: data, options: options);
  }

  Future<Response<T>> delete<T>(
      String path, {
        dynamic data,
        Options? options,
      }) async {
    return _dio.delete<T>(path, data: data, options: options);
  }
}

///
/// 🔐 Handles automatic token injection
///
class _AuthInterceptor extends Interceptor {
  final LocalStorageService _storage;

  _AuthInterceptor(this._storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print("➡️ [REQUEST] ${options.method} ${options.uri}");
    print("➡️ Body: ${options.data}");
    final token = _storage.getString("token");
    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("✅ [SUCCESS] ${response.requestOptions.method} ${response.requestOptions.uri}");
    print("✅ Status: ${response.statusCode}");
    print("✅ Data: ${response.data}");
    super.onResponse(response, handler);
  }


}
