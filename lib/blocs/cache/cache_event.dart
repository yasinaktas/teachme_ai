import 'package:teachme_ai/constants/app_colors.dart';

abstract class CacheEvent {}

class CacheInitialEvent extends CacheEvent {}

class GetLanguageEvent extends CacheEvent {}

class GetUsernameEvent extends CacheEvent {}

class SetLanguageEvent extends CacheEvent {
  final String language;

  SetLanguageEvent(this.language);
}

class SetUsernameEvent extends CacheEvent {
  final String username;

  SetUsernameEvent(this.username);
}

class GetEmailEvent extends CacheEvent {}

class SetEmailEvent extends CacheEvent {
  final String email;

  SetEmailEvent(this.email);
}

class GetUserIdEvent extends CacheEvent {}

class SetUserIdEvent extends CacheEvent {
  final String userId;

  SetUserIdEvent(this.userId);
}

class GetAppLanguageEvent extends CacheEvent {}

class SetAppLanguageEvent extends CacheEvent {
  final String appLanguage;

  SetAppLanguageEvent(this.appLanguage);
}

class GetThemeEvent extends CacheEvent {}

class SetThemeEvent extends CacheEvent {
  final AppColors theme;

  SetThemeEvent(this.theme);
}

class ClearAllEvent extends CacheEvent {}
