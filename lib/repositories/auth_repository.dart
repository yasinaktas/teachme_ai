import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:teachme_ai/exceptions/access_token_error.dart';
import 'package:teachme_ai/exceptions/not_login_error.dart';
import 'package:teachme_ai/services/dio_client.dart';

class AuthRepository {
  final Dio _dio = DioClient().dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> exchangeFirebaseToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw NotLoginErrorException();

    try {
      final idToken = await user.getIdToken();

      final res = await _dio.post(
        '/auth/exchange-token',
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );

      final accessToken = res.data['access_token'];
      final accessTokenExpiry = res.data['expires_at'];
      final refreshToken = res.data['refresh_token'];
      final refreshTokenExpiry = res.data['refresh_expires_at'];

      if (accessToken == null || refreshToken == null) {
        throw AccessTokenErrorException();
      }

      await _storage.write(key: 'custom_jwt', value: accessToken);
      await _storage.write(
        key: 'custom_jwt_expiry',
        value: accessTokenExpiry.toString(),
      );
      await _storage.write(key: 'refresh_token', value: refreshToken);
      await _storage.write(
        key: 'refresh_token_expiry',
        value: refreshTokenExpiry.toString(),
      );
    } catch (e) {
      throw AccessTokenErrorException();
    }
  }

  Future<void> deleteTokens() async {
    await _storage.delete(key: 'custom_jwt');
    await _storage.delete(key: 'custom_jwt_expiry');
    await _storage.delete(key: 'refresh_token');
    await _storage.delete(key: 'refresh_token_expiry');
  }
}
