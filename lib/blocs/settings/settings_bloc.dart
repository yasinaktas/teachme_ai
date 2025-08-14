import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/settings/settings_event.dart';
import 'package:teachme_ai/blocs/settings/settings_state.dart';
import 'package:teachme_ai/repositories/interfaces/i_settings_repository.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final ISettingsRepository _settingsRepository;
  SettingsBloc(this._settingsRepository)
    : super(
        SettingsState(
          username: "",
          language: "",
          email: "",
          userId: "",
          appLanguage: "",
        ),
      ) {
    on<SettingsInitialEvent>(_onSettingsInitialEvent);
    on<GetLanguageEvent>(_onGetLanguageEvent);
    on<GetUsernameEvent>(_onGetUsernameEvent);
    on<SetLanguageEvent>(_onSetLanguageEvent);
    on<SetUsernameEvent>(_onSetUsernameEvent);
    on<GetEmailEvent>(_onGetEmailEvent);
    on<SetEmailEvent>(_onSetEmailEvent);
    on<GetUserIdEvent>(_onGetUserIdEvent);
    on<SetUserIdEvent>(_onSetUserIdEvent);
    on<GetAppLanguageEvent>(_onGetAppLanguageEvent);
    on<SetAppLanguageEvent>(_onSetAppLanguageEvent);
    on<ClearAllEvent>(_onClearAllEvent);
  }

  Future<void> _onSettingsInitialEvent(
    SettingsInitialEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final username = await _settingsRepository.getUsername();
    final language = await _settingsRepository.getLanguage();
    final email = await _settingsRepository.getEmail();
    final userId = await _settingsRepository.getUserId();
    final appLanguage = await _settingsRepository.getAppLanguage();
    emit(
      state.copyWith(
        username: username,
        language: language,
        email: email,
        userId: userId,
        appLanguage: appLanguage,
      ),
    );
  }

  Future<void> _onGetLanguageEvent(
    GetLanguageEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final language = await _settingsRepository.getLanguage();
    emit(state.copyWith(language: language));
  }

  Future<void> _onGetUsernameEvent(
    GetUsernameEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final username = await _settingsRepository.getUsername();
    emit(state.copyWith(username: username));
  }

  Future<void> _onSetLanguageEvent(
    SetLanguageEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await _settingsRepository.setLanguage(event.language);
    emit(state.copyWith(language: event.language));
  }

  Future<void> _onSetUsernameEvent(
    SetUsernameEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await _settingsRepository.setUsername(event.username);
    emit(state.copyWith(username: event.username));
  }

  Future<void> _onGetEmailEvent(
    GetEmailEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final email = await _settingsRepository.getEmail();
    emit(state.copyWith(email: email));
  }

  Future<void> _onSetEmailEvent(
    SetEmailEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await _settingsRepository.setEmail(event.email);
    emit(state.copyWith(email: event.email));
  }

  Future<void> _onGetUserIdEvent(
    GetUserIdEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final userId = await _settingsRepository.getUserId();
    emit(state.copyWith(userId: userId));
  }

  Future<void> _onSetUserIdEvent(
    SetUserIdEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await _settingsRepository.setUserId(event.userId);
    emit(state.copyWith(userId: event.userId));
  }

  Future<void> _onGetAppLanguageEvent(
    GetAppLanguageEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final appLanguage = await _settingsRepository.getAppLanguage();
    emit(state.copyWith(appLanguage: appLanguage));
  }

  Future<void> _onSetAppLanguageEvent(
    SetAppLanguageEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await _settingsRepository.setAppLanguage(event.appLanguage);
    emit(state.copyWith(appLanguage: event.appLanguage));
  }

  Future<void> _onClearAllEvent(
    ClearAllEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await _settingsRepository.setUsername("");
    await _settingsRepository.setEmail("");
    await _settingsRepository.setUserId("");
    await _settingsRepository.setLanguage("");
    await _settingsRepository.setAppLanguage("");
    emit(
      SettingsState(
        username: "",
        email: "",
        userId: "",
        language: "",
        appLanguage: "",
      ),
    );
  }
}
