import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!options.path.contains('/auth/exchange-token')) {
      final token = await _storage.read(key: 'custom_jwt');
      if (token == null) {
        return handler.reject(
          DioException(
            requestOptions: options,
            error: "No stored JWT",
            type: DioExceptionType.cancel,
          ),
        );
      }

      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }
}
