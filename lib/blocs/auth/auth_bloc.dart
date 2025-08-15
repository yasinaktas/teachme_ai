import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/cache/cache_bloc.dart';
import 'package:teachme_ai/blocs/cache/cache_event.dart';
import 'package:teachme_ai/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final CacheBloc _cacheBloc;
  final AuthRepository _authRepository;
  StreamSubscription<User?>? _authSubscription;

  AuthBloc(
    this._firebaseAuth,
    this._firestore,
    this._cacheBloc,
    this._authRepository,
  ) : super(AuthInitial()) {
    _authSubscription = _firebaseAuth.authStateChanges().listen((user) {
      add(AuthStateChanged(user?.uid));
    });

    on<AppStarted>((event, emit) async {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        await _authRepository.deleteTokens();
        emit(Unauthenticated());
        return;
      }
      final uid = user.uid;
      final cacheUserId = _cacheBloc.state.userId;
      if (cacheUserId.isNotEmpty && cacheUserId == uid) {
        final username = _cacheBloc.state.username;
        final email = _cacheBloc.state.email;
        if (username.isNotEmpty && email.isNotEmpty) {
          await _authRepository.exchangeFirebaseToken();
          emit(Authenticated(uid: uid, username: username, email: email));
          return;
        }
      }
      try {
        final doc = await _firestore.collection('users').doc(uid).get();
        if (doc.exists) {
          final data = doc.data()!;
          final username = data['username'] ?? '';
          final email = data['email'] ?? '';

          if (username.isEmpty || email.isEmpty) {
            await _authRepository.deleteTokens();
            emit(Unauthenticated());
          } else {
            await _authRepository.exchangeFirebaseToken();
            _cacheBloc.add(SetUsernameEvent(username));
            _cacheBloc.add(SetEmailEvent(email));
            _cacheBloc.add(SetUserIdEvent(uid));
            emit(Authenticated(uid: uid, username: username, email: email));
          }
        } else {
          await _authRepository.deleteTokens();
          emit(Unauthenticated());
        }
      } catch (e) {
        await _authRepository.deleteTokens();
        emit(Unauthenticated());
      }
    });

    on<SignInRequested>((event, emit) async {
      emit(AuthLoading());
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(AuthError("Email and password cannot be empty"));
        return;
      }
      try {
        await _firebaseAuth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        final user = _firebaseAuth.currentUser;
        if (user != null) {
          await _authRepository.exchangeFirebaseToken();
        }
      } on FirebaseAuthException catch (e) {
        emit(AuthError(e.message ?? "Please check your credentials"));
        await _authRepository.deleteTokens();
        emit(Unauthenticated());
      }
    });

    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final userCredential = await _firebaseAuth
            .createUserWithEmailAndPassword(
              email: event.email,
              password: event.password,
            );
        final uid = userCredential.user?.uid;
        if (uid != null) {
          await _firestore.collection('users').doc(uid).set({
            'username': event.username,
            'email': event.email,
            'createdAt': FieldValue.serverTimestamp(),
          });
          await _authRepository.exchangeFirebaseToken();
          _cacheBloc.add(SetUsernameEvent(event.username));
          _cacheBloc.add(SetEmailEvent(event.email));
          _cacheBloc.add(SetUserIdEvent(uid));
          emit(
            Authenticated(
              uid: uid,
              username: event.username,
              email: event.email,
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        emit(
          AuthError(
            e.message ?? "There was an error signing up. Please try again.",
          ),
        );
        await _authRepository.deleteTokens();
        emit(Unauthenticated());
      }
    });

    on<SignOutRequested>((event, emit) async {
      _cacheBloc.add(SetUsernameEvent(""));
      _cacheBloc.add(SetEmailEvent(""));
      _cacheBloc.add(SetUserIdEvent(""));
      await _authRepository.deleteTokens();
      await _firebaseAuth.signOut();
    });

    on<AuthStateChanged>((event, emit) async {
      if (event.uid != null) {
        final uid = event.uid!;

        final cacheUserId = _cacheBloc.state.userId;
        if (cacheUserId.isNotEmpty && cacheUserId == uid) {
          final username = _cacheBloc.state.username;
          final email = _cacheBloc.state.email;
          if (username.isNotEmpty && email.isNotEmpty) {
            await _authRepository.exchangeFirebaseToken();
            emit(Authenticated(uid: uid, username: username, email: email));
            return;
          }
        }

        try {
          final doc = await _firestore.collection('users').doc(uid).get();
          if (doc.exists == false) {
            debugPrint("User document is not exists");
            await _authRepository.deleteTokens();
            emit(Unauthenticated());
            return;
          }
          final data = doc.data()!;
          final username = data['username'] ?? '';
          final email = data['email'] ?? '';

          if (username.isEmpty || email.isEmpty) {
            debugPrint("User document is incomplete");
            await _authRepository.deleteTokens();
            emit(Unauthenticated());
            return;
          }
          _cacheBloc.add(SetUsernameEvent(username));
          _cacheBloc.add(SetEmailEvent(email));
          _cacheBloc.add(SetUserIdEvent(uid));
          await _authRepository.exchangeFirebaseToken();
          debugPrint("User authenticated: $username, $email");
          emit(Authenticated(uid: uid, username: username, email: email));
        } catch (e) {
          debugPrint('Error fetching user data: $e');
          await _authRepository.deleteTokens();
          emit(Unauthenticated());
        }
      } else {
        debugPrint("User is unauthenticated");
        await _authRepository.deleteTokens();
        emit(Unauthenticated());
      }
    });

    on<DeleteAccountRequested>((event, emit) async {
      emit(AuthLoading());

      final user = _firebaseAuth.currentUser;

      if (user == null) {
        emit(AuthError("No user logged in"));
        return;
      }

      try {
        final uid = user.uid;
        await _firestore.collection('users').doc(uid).delete();
        await user.delete();
        await _authRepository.deleteTokens();
        _cacheBloc.add(ClearAllEvent());
        emit(Unauthenticated());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          emit(AuthError("Please reauthenticate and try again"));
        } else {
          emit(AuthError(e.message ?? "Account deletion failed"));
        }
      } catch (e) {
        emit(AuthError("Something went wrong: $e"));
      }
    });
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
