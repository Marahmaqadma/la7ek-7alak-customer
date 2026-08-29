import 'package:dio/dio.dart';
import 'package:la7ek_7alak/core/constants/api_constants.dart';
import 'package:la7ek_7alak/features/auth/data/models/login_request_body.dart';
import 'package:la7ek_7alak/features/auth/data/models/register_request_body.dart';
import 'package:la7ek_7alak/features/auth/data/models/login_response.dart';
import 'package:la7ek_7alak/features/auth/data/models/register_response.dart';
import '../models/forgot_password_request_body.dart';
import '../models/forgot_password_response.dart';
import '../models/verify_otp_request_body.dart';
import '../models/verify_otp_response.dart';
import '../models/reset_password_request_body.dart';
import '../models/reset_password_response.dart';
// ==========================================
// 1. العقد (Interface) الذي يحدد الفانكشنز المطلوبة
// ==========================================
abstract class AuthRemoteDataSource {
  // تم تغيير UserModel إلى LoginResponse لدالة تسجيل الدخول
  Future<LoginResponse> login(LoginRequestBody body);
  Future<RegisterResponse> register(RegisterRequestBody body);
  Future<ForgotPasswordResponse> forgotPassword(ForgotPasswordRequestBody body);
  Future<VerifyOtpResponse> verifyOtp(VerifyOtpRequestBody body);
  Future<ResetPasswordResponse> resetPassword(ResetPasswordRequestBody body);
}

// ==========================================
// 2. التطبيق الفعلي للـ API باستخدام مكتبة Dio
// ==========================================
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);
  // إرسال طلب تسجيل الدخول الموحد (للزبر والتاجر)
  @override
  Future<LoginResponse> login(LoginRequestBody body) async {
    final response = await dio.post(
      '${ApiConstants.baseUrl}${ApiConstants.login}',
      data: body.toJson(),
    );
    // استخدام LoginResponse.fromJson بدلاً من UserModel
    return LoginResponse.fromJson(response.data);
  }

  // تنفيذ طلب إنشاء الحساب وإرسال البيانات للسيرفر
@override
Future<RegisterResponse> register(RegisterRequestBody body) async {
final response = await dio.post(
'${ApiConstants.baseUrl}${ApiConstants.register}',
data: body.toJson(),
);
return RegisterResponse.fromJson(response.data);
}
  @override
  Future<ForgotPasswordResponse> forgotPassword(ForgotPasswordRequestBody body) async {
    final response = await dio.post(
      '${ApiConstants.baseUrl}${ApiConstants.forgotPassword}',
      data: body.toJson(),
    );
    return ForgotPasswordResponse.fromJson(response.data);
  }
  @override
  Future<VerifyOtpResponse> verifyOtp(VerifyOtpRequestBody body) async {
    final response = await dio.post(
      '${ApiConstants.baseUrl}${ApiConstants.verifyOtp}',
      data: body.toJson(),
    );
    return VerifyOtpResponse.fromJson(response.data);
  }
  @override
  Future<ResetPasswordResponse> resetPassword(ResetPasswordRequestBody body) async {
    final response = await dio.post(
      '${ApiConstants.baseUrl}${ApiConstants.resetPassword}',
      data: body.toJson(),
    );
    return ResetPasswordResponse.fromJson(response.data);
  }
}