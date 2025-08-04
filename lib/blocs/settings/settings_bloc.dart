import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/settings/settings_event.dart';
import 'package:teachme_ai/blocs/settings/settings_state.dart';
import 'package:teachme_ai/repositories/i_settings_repository.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final ISettingsRepository _settingsRepository;
  SettingsBloc(this._settingsRepository)
    : super(SettingsState(username: "", language: "")) {
    on<SettingsInitialEvent>(_onSettingsInitialEvent);
    on<GetLanguageEvent>(_onGetLanguageEvent);
    on<GetUsernameEvent>(_onGetUsernameEvent);
    on<SetLanguageEvent>(_onSetLanguageEvent);
    on<SetUsernameEvent>(_onSetUsernameEvent);
  }

  Future<void> _onSettingsInitialEvent(
    SettingsInitialEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final username = await _settingsRepository.getUsername();
    final language = await _settingsRepository.getLanguage();
    emit(state.copyWith(username: username, language: language));
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
}
