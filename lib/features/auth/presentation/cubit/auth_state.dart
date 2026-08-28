import 'package:la7ek_7alak/features/auth/domain/entities/user.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, failure }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? message;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.message,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? message,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      message: message ?? this.message,
    );
  }
}
