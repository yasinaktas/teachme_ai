class SettingsState {
  final String userId;
  final String username;
  final String email;
  final String language;

  SettingsState({
    required this.userId,
    required this.username,
    required this.email,
    required this.language,
  });

  SettingsState copyWith({
    String? userId,
    String? username,
    String? email,
    String? language,
  }) {
    return SettingsState(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      username: username ?? this.username,
      language: language ?? this.language,
    );
  }
}
