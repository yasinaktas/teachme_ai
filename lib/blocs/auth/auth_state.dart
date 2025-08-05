import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final String uid;
  final String username;
  final String email;

  const Authenticated({
    required this.uid,
    required this.username,
    required this.email,
  });

  @override
  List<Object?> get props => [uid, username, email];
}

class Unauthenticated extends AuthState {
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
