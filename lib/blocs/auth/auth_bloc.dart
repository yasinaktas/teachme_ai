import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  StreamSubscription<User?>? _authSubscription;

  AuthBloc(this._firebaseAuth, this._firestore) : super(AuthInitial()) {
    _authSubscription = _firebaseAuth.authStateChanges().listen((user) {
      add(AuthStateChanged(user?.uid));
    });

    on<AppStarted>((event, emit) {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        emit(Authenticated(user.uid));
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
      await _firebaseAuth.signOut();
    });

    on<AuthStateChanged>((event, emit) {
      if (event.uid != null) {
        debugPrint("User is authenticated with UID: ${event.uid}");
        emit(Authenticated(event.uid!));
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
