class SettingsState {
  final String username;
  final String language;

  SettingsState({
    required this.username,
    required this.language,
  });

  SettingsState copyWith({
    String? username,
    String? language,
  }) {
    return SettingsState(
      username: username ?? this.username,
      language: language ?? this.language,
    );
  }
}