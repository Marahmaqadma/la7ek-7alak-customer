part of 'login_cubit.dart';

// الحالات الممكنة لعملية تسجيل الدخول التي تتابعها الواجهة.
abstract class LoginState {}

// الحالة الأولية قبل بدء طلب تسجيل الدخول.
class LoginInitial extends LoginState {}

// حالة انتظار نتيجة طلب تسجيل الدخول.
class LoginLoading extends LoginState {}

// يحمل بيانات نجاح تسجيل الدخول لعرض النتيجة أو الانتقال.
class LoginSuccess extends LoginState {
  final LoginResponse loginResponse;

  LoginSuccess(this.loginResponse);
}

// يحمل رسالة فشل تسجيل الدخول لعرضها للمستخدم.
class LoginError extends LoginState {
  final String error;

  LoginError(this.error);
}
