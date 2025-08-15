import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/cache/cache_event.dart';
import 'package:teachme_ai/blocs/cache/cache_state.dart';
import 'package:teachme_ai/repositories/interfaces/i_cache_repository.dart';

class CacheBloc extends Bloc<CacheEvent, CacheState> {
  final ICacheRepository _cacheRepository;
  CacheBloc(this._cacheRepository)
    : super(
        CacheState(
          username: "",
          language: "",
          email: "",
          userId: "",
          appLanguage: "",
        ),
      ) {
    on<CacheInitialEvent>(_onCacheInitialEvent);
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

  Future<void> _onCacheInitialEvent(
    CacheInitialEvent event,
    Emitter<CacheState> emit,
  ) async {
    final username = await _cacheRepository.getUsername();
    final language = await _cacheRepository.getLanguage();
    final email = await _cacheRepository.getEmail();
    final userId = await _cacheRepository.getUserId();
    final appLanguage = await _cacheRepository.getAppLanguage();
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
    Emitter<CacheState> emit,
  ) async {
    final language = await _cacheRepository.getLanguage();
    emit(state.copyWith(language: language));
  }

  Future<void> _onGetUsernameEvent(
    GetUsernameEvent event,
    Emitter<CacheState> emit,
  ) async {
    final username = await _cacheRepository.getUsername();
    emit(state.copyWith(username: username));
  }

  Future<void> _onSetLanguageEvent(
    SetLanguageEvent event,
    Emitter<CacheState> emit,
  ) async {
    await _cacheRepository.setLanguage(event.language);
    emit(state.copyWith(language: event.language));
  }

  Future<void> _onSetUsernameEvent(
    SetUsernameEvent event,
    Emitter<CacheState> emit,
  ) async {
    await _cacheRepository.setUsername(event.username);
    emit(state.copyWith(username: event.username));
  }

  Future<void> _onGetEmailEvent(
    GetEmailEvent event,
    Emitter<CacheState> emit,
  ) async {
    final email = await _cacheRepository.getEmail();
    emit(state.copyWith(email: email));
  }

  Future<void> _onSetEmailEvent(
    SetEmailEvent event,
    Emitter<CacheState> emit,
  ) async {
    await _cacheRepository.setEmail(event.email);
    emit(state.copyWith(email: event.email));
  }

  Future<void> _onGetUserIdEvent(
    GetUserIdEvent event,
    Emitter<CacheState> emit,
  ) async {
    final userId = await _cacheRepository.getUserId();
    emit(state.copyWith(userId: userId));
  }

  Future<void> _onSetUserIdEvent(
    SetUserIdEvent event,
    Emitter<CacheState> emit,
  ) async {
    await _cacheRepository.setUserId(event.userId);
    emit(state.copyWith(userId: event.userId));
  }

  Future<void> _onGetAppLanguageEvent(
    GetAppLanguageEvent event,
    Emitter<CacheState> emit,
  ) async {
    final appLanguage = await _cacheRepository.getAppLanguage();
    emit(state.copyWith(appLanguage: appLanguage));
  }

  Future<void> _onSetAppLanguageEvent(
    SetAppLanguageEvent event,
    Emitter<CacheState> emit,
  ) async {
    await _cacheRepository.setAppLanguage(event.appLanguage);
    emit(state.copyWith(appLanguage: event.appLanguage));
  }

  Future<void> _onClearAllEvent(
    ClearAllEvent event,
    Emitter<CacheState> emit,
  ) async {
    await _cacheRepository.setUsername("");
    await _cacheRepository.setEmail("");
    await _cacheRepository.setUserId("");
    await _cacheRepository.setLanguage("English");
    await _cacheRepository.setAppLanguage("English");
    emit(
      CacheState(
        username: "",
        email: "",
        userId: "",
        language: "English",
        appLanguage: "English",
      ),
    );
  }
}
