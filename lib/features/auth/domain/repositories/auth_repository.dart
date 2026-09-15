import 'package:dartz/dartz.dart';
import '../../../../core/error/error_handler.dart';
import '../../data/models/login/login_request_body.dart';
import '../../data/models/register/register_request_body.dart';
import '../../data/models/login/login_response.dart';
import '../../data/models/register/register_response.dart';
import '../../data/models/forgot_password/forgot_password_request_body.dart';
import '../../data/models/forgot_password/forgot_password_response.dart';
import '../../data/models/verify_otp/verify_otp_request_body.dart';
import '../../data/models/verify_otp/verify_otp_response.dart';
import '../../data/models/reset_password/reset_password_request_body.dart';
import '../../data/models/reset_password/reset_password_response.dart';

// يحدد عمليات المصادقة ونتيجتها: بيانات نجاح أو خطأ قابل للعرض.
abstract class AuthRepository {
  // عقد عملية تسجيل الدخول؛ يحدد المدخلات ونوع النتيجة دون تنفيذ الاتصال هنا.
  Future<Either<ErrorHandler, LoginResponse>> login(
      LoginRequestBody loginRequestBody);
  // عقد عملية إنشاء الحساب؛ يحدد المدخلات ونوع النتيجة دون تنفيذ الاتصال هنا.
  Future<Either<ErrorHandler, RegisterResponse>> register(
      RegisterRequestBody body);
  // عقد عملية استعادة كلمة المرور؛ يحدد المدخلات ونوع النتيجة دون تنفيذ الاتصال هنا.
  Future<Either<ErrorHandler, ForgotPasswordResponse>> forgotPassword(
      ForgotPasswordRequestBody body);
  // عقد عملية التحقق من الرمز؛ يحدد المدخلات ونوع النتيجة دون تنفيذ الاتصال هنا.
  Future<Either<ErrorHandler, VerifyOtpResponse>> verifyOtp(
      VerifyOtpRequestBody body);
  // عقد عملية تعيين كلمة المرور؛ يحدد المدخلات ونوع النتيجة دون تنفيذ الاتصال هنا.
  Future<Either<ErrorHandler, ResetPasswordResponse>> resetPassword(
      ResetPasswordRequestBody body);
}
