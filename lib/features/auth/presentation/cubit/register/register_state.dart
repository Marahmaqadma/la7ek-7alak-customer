part of 'register_cubit.dart';

// الحالات الممكنة لعملية إنشاء الحساب التي تتابعها الواجهة.
abstract class RegisterState {}

// الحالة الأولية قبل بدء طلب إنشاء الحساب.
class RegisterInitial extends RegisterState {}

// حالة انتظار نتيجة طلب إنشاء الحساب.
class RegisterLoading extends RegisterState {}

// يحمل بيانات نجاح إنشاء الحساب لعرض النتيجة أو الانتقال.
class RegisterSuccess extends RegisterState {
  final RegisterResponse registerResponse;

  RegisterSuccess(this.registerResponse);
}

// يحمل رسالة فشل إنشاء الحساب لعرضها للمستخدم.
class RegisterError extends RegisterState {
  final String error;

  RegisterError(this.error);
}
