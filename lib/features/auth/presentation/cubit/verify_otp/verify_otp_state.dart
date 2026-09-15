part of 'verify_otp_cubit.dart';

// الحالات الممكنة لعملية التحقق من الرمز التي تتابعها الواجهة.
abstract class VerifyOtpState {}

// الحالة الأولية قبل بدء طلب التحقق من الرمز.
class VerifyOtpInitial extends VerifyOtpState {}

// حالة انتظار نتيجة طلب التحقق من الرمز.
class VerifyOtpLoading extends VerifyOtpState {}

// يحمل بيانات نجاح التحقق من الرمز لعرض النتيجة أو الانتقال.
class VerifyOtpSuccess extends VerifyOtpState {
  final VerifyOtpResponse verifyOtpResponse;

  VerifyOtpSuccess(this.verifyOtpResponse);
}

// يحمل رسالة فشل التحقق من الرمز لعرضها للمستخدم.
class VerifyOtpError extends VerifyOtpState {
  final String error;

  VerifyOtpError(this.error);
}
