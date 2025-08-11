import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/repositories/interfaces/i_settings_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final ISettingsRepository _settingsRepository;
  StreamSubscription<User?>? _authSubscription;

  AuthBloc(this._firebaseAuth, this._firestore, this._settingsRepository)
    : super(AuthInitial()) {
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
        }
      } on FirebaseAuthException catch (e) {
        emit(AuthError(e.message ?? "Signup failed"));
        emit(Unauthenticated());
      }
    });

    on<SignOutRequested>((event, emit) async {
      _settingsRepository.setUsername('');
      _settingsRepository.setEmail('');
      _settingsRepository.setUserId('');
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
              emit(Unauthenticated());
            } else {
              await _settingsRepository.setUsername(username);
              await _settingsRepository.setEmail(email);
              await _settingsRepository.setUserId(uid);
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
        debugPrint("User is unauthenticated");
        emit(Unauthenticated());
      }
    });
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
