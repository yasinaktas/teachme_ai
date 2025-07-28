import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth;
  StreamSubscription<User?>? _authSubscription;

  AuthBloc(this._firebaseAuth) : super(AuthInitial()) {
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
        await _firebaseAuth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
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
        emit(Authenticated(event.uid!));
      } else {
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
