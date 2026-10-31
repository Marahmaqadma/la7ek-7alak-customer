import 'package:dartz/dartz.dart';
import '../../../../core/error/error_handler.dart';
import '../../data/models/city/city_model.dart';
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
  // ينهي الجلسة ويمسح بيانات الدخول المحفوظة على الجهاز.
  Future<Either<ErrorHandler, Unit>> logout();
  // نوع حساب المستخدم المسجل (consumer | merchant) لإكمال الجلسة عند فتح
  // التطبيق، أو null إن لم يكن مسجلًا.
  Future<String?> restoreSession();
  // قائمة المدن لحقل المدينة في التسجيل.
  Future<Either<ErrorHandler, List<CityModel>>> getCities();
}
