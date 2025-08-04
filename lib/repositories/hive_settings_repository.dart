import 'package:teachme_ai/repositories/i_settings_repository.dart';
import 'package:teachme_ai/services/i_settings_service.dart';

class HiveSettingsRepository implements ISettingsRepository {
  final ISettingsService _settingsService;

  HiveSettingsRepository(this._settingsService);

  @override
  Future<String> getLanguage() async {
    return _settingsService.getLanguage();
  }

  @override
  Future<String> getUsername() async {
    return _settingsService.getUsername();
  }

  @override
  Future<void> setLanguage(String language) async {
    await _settingsService.setLanguage(language);
  }

  @override
  Future<void> setUsername(String username) async {
    await _settingsService.setUsername(username);
  }
}
