part of 'reset_password_cubit.dart';

// الحالات الممكنة لعملية تعيين كلمة المرور التي تتابعها الواجهة.
abstract class ResetPasswordState {}

// الحالة الأولية قبل بدء طلب تعيين كلمة المرور.
class ResetPasswordInitial extends ResetPasswordState {}

// حالة انتظار نتيجة طلب تعيين كلمة المرور.
class ResetPasswordLoading extends ResetPasswordState {}

// يحمل بيانات نجاح تعيين كلمة المرور لعرض النتيجة أو الانتقال.
class ResetPasswordSuccess extends ResetPasswordState {
  final ResetPasswordResponse resetPasswordResponse;

  ResetPasswordSuccess(this.resetPasswordResponse);
}

// يحمل رسالة فشل تعيين كلمة المرور لعرضها للمستخدم.
class ResetPasswordError extends ResetPasswordState {
  final String error;

  ResetPasswordError(this.error);
}
