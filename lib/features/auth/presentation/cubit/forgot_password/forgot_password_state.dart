part of 'forgot_password_cubit.dart';

abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {
  final ForgotPasswordResponse forgotPasswordResponse;

  ForgotPasswordSuccess(this.forgotPasswordResponse);
}

class ForgotPasswordError extends ForgotPasswordState {
  final String error;

  ForgotPasswordError(this.error);
}
