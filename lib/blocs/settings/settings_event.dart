import 'package:teachme_ai/constants/app_colors.dart';

abstract class SettingsEvent {}

class SettingsInitialEvent extends SettingsEvent {}

class GetLanguageEvent extends SettingsEvent {}

class GetUsernameEvent extends SettingsEvent {}

class SetLanguageEvent extends SettingsEvent {
  final String language;

  SetLanguageEvent(this.language);
}

class SetUsernameEvent extends SettingsEvent {
  final String username;

  SetUsernameEvent(this.username);
}

class GetEmailEvent extends SettingsEvent {}

class SetEmailEvent extends SettingsEvent {
  final String email;

  SetEmailEvent(this.email);
}

class GetUserIdEvent extends SettingsEvent {}

class SetUserIdEvent extends SettingsEvent {
  final String userId;

  SetUserIdEvent(this.userId);
}

class GetAppLanguageEvent extends SettingsEvent {}

class SetAppLanguageEvent extends SettingsEvent {
  final String appLanguage;

  SetAppLanguageEvent(this.appLanguage);
}

class GetThemeEvent extends SettingsEvent {}

class SetThemeEvent extends SettingsEvent {
  final AppColors theme;

  SetThemeEvent(this.theme);
}