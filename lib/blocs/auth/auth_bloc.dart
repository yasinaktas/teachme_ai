import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/settings/settings_bloc.dart';
import 'package:teachme_ai/blocs/settings/settings_event.dart';
import 'package:teachme_ai/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final SettingsBloc _settingsBloc;
  final AuthRepository _authRepository;
  StreamSubscription<User?>? _authSubscription;

  AuthBloc(
    this._firebaseAuth,
    this._firestore,
    this._settingsBloc,
    this._authRepository,
  ) : super(AuthInitial()) {
    _authSubscription = _firebaseAuth.authStateChanges().listen((user) {
      add(AuthStateChanged(user?.uid));
    });

    on<AppStarted>((event, emit) async {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        final uid = user.uid;

        try {
          final doc = await _firestore.collection('users').doc(uid).get();
          if (doc.exists) {
            final data = doc.data()!;
            final username = data['username'] ?? '';
            final email = data['email'] ?? '';

            if (username.isEmpty || email.isEmpty) {
              emit(Unauthenticated());
            } else {
              await _authRepository.getCustomJwt();
              _settingsBloc.add(SetUsernameEvent(username));
              _settingsBloc.add(SetEmailEvent(email));
              _settingsBloc.add(SetUserIdEvent(uid));
              emit(Authenticated(uid: uid, username: username, email: email));
            }
          } else {
            emit(Unauthenticated());
          }
        } catch (e) {
          debugPrint('Error fetching user data: $e');
          emit(Unauthenticated());
        }
      } else {
        emit(Unauthenticated());
      }
    });

    on<SignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await _firebaseAuth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        final user = _firebaseAuth.currentUser;
        if (user != null) {
          await _authRepository.getCustomJwt();
        }
      } on FirebaseAuthException catch (e) {
        emit(AuthError(e.message ?? "Login failed"));
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
          await _authRepository.getCustomJwt();
        }
      } on FirebaseAuthException catch (e) {
        emit(AuthError(e.message ?? "Signup failed"));
        emit(Unauthenticated());
      }
    });

    on<SignOutRequested>((event, emit) async {
      _settingsBloc.add(SetUsernameEvent(""));
      _settingsBloc.add(SetEmailEvent(""));
      _settingsBloc.add(SetUserIdEvent(""));
      await _authRepository.deleteStoredJwt();
      await _firebaseAuth.signOut();
    });

    on<AuthStateChanged>((event, emit) async {
      if (event.uid != null) {
        final uid = event.uid!;

        try {
          final doc = await _firestore.collection('users').doc(uid).get();
          if (doc.exists) {
            final data = doc.data()!;
            final username = data['username'] ?? '';
            final email = data['email'] ?? '';

            if (username.isEmpty || email.isEmpty) {
              debugPrint("User document is incomplete");
              emit(Unauthenticated());
            } else {
              _settingsBloc.add(SetUsernameEvent(username));
              _settingsBloc.add(SetEmailEvent(email));
              _settingsBloc.add(SetUserIdEvent(uid));
              await _authRepository.getCustomJwt();
              debugPrint("User authenticated: $username, $email");
              emit(Authenticated(uid: uid, username: username, email: email));
            }
          } else {
            debugPrint("User document does not exist");
            emit(Unauthenticated());
          }
        } catch (e) {
          debugPrint('Error fetching user data: $e');
          emit(Unauthenticated());
        }
      } else {
        debugPrint("User is unauthenticated");
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

        await _authRepository.deleteStoredJwt();
        _settingsBloc.add(ClearAllEvent());

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
