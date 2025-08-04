abstract interface class ISettingsRepository {
  Future<String> getUsername();
  Future<void> setUsername(String username);

  Future<String> getLanguage();
  Future<void> setLanguage(String language);
}