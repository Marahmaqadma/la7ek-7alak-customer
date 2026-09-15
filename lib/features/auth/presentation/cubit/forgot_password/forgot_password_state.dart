part of 'forgot_password_cubit.dart';

// الحالات الممكنة لعملية استعادة كلمة المرور التي تتابعها الواجهة.
abstract class ForgotPasswordState {}

// الحالة الأولية قبل بدء طلب استعادة كلمة المرور.
class ForgotPasswordInitial extends ForgotPasswordState {}

// حالة انتظار نتيجة طلب استعادة كلمة المرور.
class ForgotPasswordLoading extends ForgotPasswordState {}

// يحمل بيانات نجاح استعادة كلمة المرور لعرض النتيجة أو الانتقال.
class ForgotPasswordSuccess extends ForgotPasswordState {
  final ForgotPasswordResponse forgotPasswordResponse;

  ForgotPasswordSuccess(this.forgotPasswordResponse);
}

// يحمل رسالة فشل استعادة كلمة المرور لعرضها للمستخدم.
class ForgotPasswordError extends ForgotPasswordState {
  final String error;

  ForgotPasswordError(this.error);
}
