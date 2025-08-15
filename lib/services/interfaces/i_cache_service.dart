abstract interface class ICacheService {
  Future<String> getUsername();
  Future<void> setUsername(String username);

  Future<String> getEmail();
  Future<void> setEmail(String email);

  Future<String> getLanguage();
  Future<void> setLanguage(String language);

  Future<String> getAppLanguage();
  Future<void> setAppLanguage(String language);

  Future<String> getUserId();
  Future<void> setUserId(String userId);
}
