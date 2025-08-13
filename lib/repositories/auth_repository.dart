import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    hide Options;
import 'package:teachme_ai/exceptions/access_token_error.dart';
import 'package:teachme_ai/exceptions/not_login_error.dart';
import 'package:teachme_ai/services/dio_client.dart';

class AuthRepository {
  final Dio _dio = DioClient().dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /*Future<String> getCustomJwt() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw NotLoginErrorException();

    final idToken = await user.getIdToken();

    final res = await _dio.post(
      '/auth/exchange-token',
      options: Options(headers: {'Authorization': 'Bearer $idToken'}),
    );

    final customJwt = res.data['access_token'];

    await _storage.write(key: 'custom_jwt', value: customJwt);

    return customJwt;
  }*/

  Future<String> getCustomJwt() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw NotLoginErrorException();

    try {
      final idToken = await user.getIdToken();

      final res = await _dio.post(
        '/auth/exchange-token',
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );

      final customJwt = res.data['access_token'];
      if (customJwt == null) {
        throw AccessTokenErrorException();
      }

      await _storage.write(key: 'custom_jwt', value: customJwt);
      return customJwt;
    } catch (e) {
      throw AccessTokenErrorException();
    }
  }

  Future<String?> getStoredJwt() async {
    return await _storage.read(key: 'custom_jwt');
  }

  Future<void> deleteStoredJwt() async {
    await _storage.delete(key: 'custom_jwt');
  }
}
