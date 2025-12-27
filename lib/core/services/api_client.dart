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
          "x-app-bypass": "68312D38-5D2F-4375-89C7-BAE1D3478228",
          // ❌ removed Authorization here (it must be runtime-injected)
        },
      ),
    );

    _dio.interceptors.addAll([
      _AuthInterceptor(_storage),
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

  Future<Response<T>> patch<T>(
      String path, {
        dynamic data,
        Options? options,
      }) async {
    return _dio.patch<T>(path, data: data, options: options);
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
/// 🔐 Auth Interceptor: attaches fresh tokens safely
///
class _AuthInterceptor extends Interceptor {
  final LocalStorageService _storage;

  _AuthInterceptor(this._storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _storage.getString("secret");

    print("➡️ [REQUEST] ${options.method} ${options.uri}");
    if (options.data != null) print("➡️ Body: ${options.data}");

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

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print("❌ [ERROR] ${err.requestOptions.method} ${err.requestOptions.uri}");
    print("❌ Message: ${err.message}");

    super.onError(err, handler);
  }
}
