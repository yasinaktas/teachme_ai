import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Auth gerekmeyen endpointler
    if (options.path.contains('/auth/exchange-token') ||
        options.path.contains('/auth/refresh-token')) {
      return super.onRequest(options, handler);
    }

    String? accessToken = await _storage.read(key: 'custom_jwt');
    String? expiresAtStr = await _storage.read(key: 'custom_jwt_expiry');

    if (accessToken == null || expiresAtStr == null) {
      return handler.reject(
        DioException(
          requestOptions: options,
          error: "No stored JWT",
          type: DioExceptionType.cancel,
        ),
      );
    }

    final expiresAt = DateTime.fromMillisecondsSinceEpoch(int.parse(expiresAtStr) * 1000);
    final now = DateTime.now().toUtc();

    // Access token süresi dolmuşsa yenile
    if (now.isAfter(expiresAt)) {
      final refreshToken = await _storage.read(key: 'refresh_token');
      if (refreshToken != null) {
        try {
          final dio = Dio(BaseOptions(baseUrl: "https://teachmeai-8f494e051a11.herokuapp.com"));
          final res = await dio.post(
            '/auth/refresh-token',
            data: {'refresh_token': refreshToken},
          );

          accessToken = res.data['access_token'];
          final newExpiry = res.data['expires_at'];

          await _storage.write(key: 'custom_jwt', value: accessToken);
          await _storage.write(key: 'custom_jwt_expiry', value: newExpiry.toString());
        } catch (e) {
          return handler.reject(
            DioException(
              requestOptions: options,
              error: "Token refresh failed",
              type: DioExceptionType.cancel,
            ),
          );
        }
      }
    }

    options.headers['Authorization'] = 'Bearer $accessToken';
    super.onRequest(options, handler);
  }
}


