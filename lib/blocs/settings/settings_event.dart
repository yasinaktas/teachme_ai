abstract class SettingsEvent {}

class SettingsInitialEvent extends SettingsEvent {}

class GetLanguageEvent extends SettingsEvent {
}

class GetUsernameEvent extends SettingsEvent {
}

class SetLanguageEvent extends SettingsEvent {
  final String language;

  SetLanguageEvent(this.language);
}

class SetUsernameEvent extends SettingsEvent {
  final String username;

  SetUsernameEvent(this.username);
}