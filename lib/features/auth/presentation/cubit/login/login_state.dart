part of 'login_cubit.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginResponse loginResponse;

  LoginSuccess(this.loginResponse);
}

class LoginError extends LoginState {
  final String error;

  LoginError(this.error);
}
