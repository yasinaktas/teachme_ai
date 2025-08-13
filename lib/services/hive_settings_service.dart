import 'package:hive/hive.dart';
import 'package:teachme_ai/services/interfaces/i_settings_service.dart';

class HiveSettingsService implements ISettingsService {
  final Box<dynamic> _settingsBox = Hive.box<dynamic>('settings');

  @override
  Future<String> getAppLanguage() async {
    return _settingsBox.get("app_language", defaultValue: "English");
  }

  @override
  Future<void> setAppLanguage(String language) async {
    _settingsBox.put("app_language", language);
  }

  @override
  Future<String> getLanguage() async {
    return _settingsBox.get("language", defaultValue: "English");
  }

  @override
  Future<String> getUsername() async {
    return _settingsBox.get("username", defaultValue: "");
  }

  @override
  Future<void> setLanguage(String language) async {
    _settingsBox.put("language", language);
  }

  @override
  Future<void> setUsername(String username) async {
    _settingsBox.put("username", username);
  }

  @override
  Future<String> getEmail() async {
    return _settingsBox.get("email", defaultValue: "");
  }

  @override
  Future<void> setEmail(String email) async {
    return _settingsBox.put("email", email);
  }

  @override
  Future<String> getUserId() async {
    return _settingsBox.get("userId", defaultValue: "");
  }

  @override
  Future<void> setUserId(String userId) async {
    return _settingsBox.put("userId", userId);
  }
}
