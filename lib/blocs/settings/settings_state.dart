import 'package:equatable/equatable.dart';
import 'package:teachme_ai/constants/app_colors.dart';

class SettingsState extends Equatable {
  final String userId;
  final String username;
  final String email;
  final String language;
  final String appLanguage;

  const SettingsState({
    required this.userId,
    required this.username,
    required this.email,
    required this.language,
    required this.appLanguage,
  });

  SettingsState copyWith({
    String? userId,
    String? username,
    String? email,
    String? language,
    String? appLanguage,
    AppColors? theme,
  }) {
    return SettingsState(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      username: username ?? this.username,
      language: language ?? this.language,
      appLanguage: appLanguage ?? this.appLanguage,
    );
  }

  @override
  List<Object?> get props => [userId, username, email, language, appLanguage];
}
