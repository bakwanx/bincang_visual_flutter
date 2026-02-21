import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../infrastructure/logging_interceptor.dart';
import '../../utils/log/print_debug_log.dart';
import 'api_constants.dart';
import '../error/exceptions.dart';

class ApiClient {
  final Dio dio;
  final SharedPreferences sharedPreferences;

  ApiClient({required this.dio, required this.sharedPreferences}) {
    dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    dio.interceptors.add(LoggingInterceptor());

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _getAuthToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioError error, handler) {
          _handleError(error);
          return handler.next(error);
        },
      ),
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await dio.get(path, queryParameters: queryParameters);
    } on DioError catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await dio.post(path, data: data);
    } on DioError catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await dio.put(path, data: data);
    } on DioError catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> delete(String path) async {
    try {
      return await dio.delete(path);
    } on DioError catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<String?> _getAuthToken() async {
    final token = sharedPreferences.getString("auth_token");

    return token;
  }

  Exception _handleDioError(DioError error) {
    switch (error.type) {
      case DioErrorType.connectionTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        return NetworkException('Connection timeout');
      case DioErrorType.badResponse:
        return ServerException(error.response?.data['error'] ?? 'Server error');
      case DioErrorType.cancel:
        return ServerException('Request cancelled');
      default:
        return NetworkException('Network error');
    }
  }

  void _handleError(DioError error) {
    // Log error to analytics
    printDebugLog(tag: 'API Client', message: 'API Error: ${error.message}');
  }
}
