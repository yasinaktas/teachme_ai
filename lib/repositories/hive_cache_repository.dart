import 'package:teachme_ai/repositories/interfaces/i_cache_repository.dart';
import 'package:teachme_ai/services/interfaces/i_cache_service.dart';

class HiveCacheRepository implements ICacheRepository {
  final ICacheService _cacheService;

  HiveCacheRepository(this._cacheService);

  @override
  Future<String> getLanguage() async {
    return _cacheService.getLanguage();
  }

  @override
  Future<String> getUsername() async {
    return _cacheService.getUsername();
  }

  @override
  Future<void> setLanguage(String language) async {
    await _cacheService.setLanguage(language);
  }

  @override
  Future<void> setUsername(String username) async {
    await _cacheService.setUsername(username);
  }

  @override
  Future<String> getEmail() async {
    return _cacheService.getEmail();
  }

  @override
  Future<void> setEmail(String email) async {
    return _cacheService.setEmail(email);
  }

  @override
  Future<String> getUserId() async {
    return _cacheService.getUserId();
  }

  @override
  Future<void> setUserId(String userId) async {
    return _cacheService.setUserId(userId);
  }

  @override
  Future<String> getAppLanguage() {
    return _cacheService.getAppLanguage();
  }

  @override
  Future<void> setAppLanguage(String language) {
    return _cacheService.setAppLanguage(language);
  }
}
