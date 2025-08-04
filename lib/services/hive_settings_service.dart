import 'package:hive/hive.dart';
import 'package:teachme_ai/services/i_settings_service.dart';

class HiveSettingsService implements ISettingsService{

  final Box<dynamic> _settingsBox = Hive.box<dynamic>('settings');

  @override
  Future<String> getLanguage() async {
    return _settingsBox.get("language",defaultValue: "English");
  }

  @override
  Future<String> getUsername() async{
    return _settingsBox.get("username", defaultValue: "Guest");
  }

  @override
  Future<void> setLanguage(String language) async{
    _settingsBox.put("language", language);
  }

  @override
  Future<void> setUsername(String username) async{
    _settingsBox.put("username", username);
  }

}