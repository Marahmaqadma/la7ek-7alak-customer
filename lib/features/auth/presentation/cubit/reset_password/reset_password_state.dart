part of 'reset_password_cubit.dart';

abstract class ResetPasswordState {}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {
  final ResetPasswordResponse resetPasswordResponse;

  ResetPasswordSuccess(this.resetPasswordResponse);
}

class ResetPasswordError extends ResetPasswordState {
  final String error;

  ResetPasswordError(this.error);
}
