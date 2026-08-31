part of 'verify_otp_cubit.dart';

abstract class VerifyOtpState {}

class VerifyOtpInitial extends VerifyOtpState {}

class VerifyOtpLoading extends VerifyOtpState {}

class VerifyOtpSuccess extends VerifyOtpState {
  final VerifyOtpResponse verifyOtpResponse;

  VerifyOtpSuccess(this.verifyOtpResponse);
}

class VerifyOtpError extends VerifyOtpState {
  final String error;

  VerifyOtpError(this.error);
}
