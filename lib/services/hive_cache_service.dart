import 'package:hive/hive.dart';
import 'package:teachme_ai/services/interfaces/i_cache_service.dart';

class HiveCacheService implements ICacheService {
  final Box<dynamic> _cacheBox = Hive.box<dynamic>('settings');

  @override
  Future<String> getAppLanguage() async {
    return _cacheBox.get("app_language", defaultValue: "English");
  }

  @override
  Future<void> setAppLanguage(String language) async {
    _cacheBox.put("app_language", language);
  }

  @override
  Future<String> getLanguage() async {
    return _cacheBox.get("language", defaultValue: "English");
  }

  @override
  Future<String> getUsername() async {
    return _cacheBox.get("username", defaultValue: "");
  }

  @override
  Future<void> setLanguage(String language) async {
    _cacheBox.put("language", language);
  }

  @override
  Future<void> setUsername(String username) async {
    _cacheBox.put("username", username);
  }

  @override
  Future<String> getEmail() async {
    return _cacheBox.get("email", defaultValue: "");
  }

  @override
  Future<void> setEmail(String email) async {
    return _cacheBox.put("email", email);
  }

  @override
  Future<String> getUserId() async {
    return _cacheBox.get("userId", defaultValue: "");
  }

  @override
  Future<void> setUserId(String userId) async {
    return _cacheBox.put("userId", userId);
  }
}
