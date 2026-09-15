import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:la7ek_7alak/core/constants/api_constants.dart';
import 'package:la7ek_7alak/features/auth/data/models/login/login_request_body.dart';
import 'package:la7ek_7alak/features/auth/data/models/register/register_request_body.dart';
import 'package:la7ek_7alak/features/auth/data/models/login/login_response.dart';
import 'package:la7ek_7alak/features/auth/data/models/register/register_response.dart';
import '../models/forgot_password/forgot_password_request_body.dart';
import '../models/forgot_password/forgot_password_response.dart';
import '../models/verify_otp/verify_otp_request_body.dart';
import '../models/verify_otp/verify_otp_response.dart';
import '../models/reset_password/reset_password_request_body.dart';
import '../models/reset_password/reset_password_response.dart';

// يحدد عمليات المصادقة المطلوبة من أي مصدر بيانات خارجي.
abstract class AuthRemoteDataSource {

  // عقد عملية تسجيل الدخول؛ يحدد المدخلات ونوع النتيجة دون تنفيذ الاتصال هنا.
  Future<LoginResponse> login(LoginRequestBody body);
  // عقد عملية إنشاء الحساب؛ يحدد المدخلات ونوع النتيجة دون تنفيذ الاتصال هنا.
  Future<RegisterResponse> register(RegisterRequestBody body);
  // عقد عملية استعادة كلمة المرور؛ يحدد المدخلات ونوع النتيجة دون تنفيذ الاتصال هنا.
  Future<ForgotPasswordResponse> forgotPassword(ForgotPasswordRequestBody body);
  // عقد عملية التحقق من الرمز؛ يحدد المدخلات ونوع النتيجة دون تنفيذ الاتصال هنا.
  Future<VerifyOtpResponse> verifyOtp(VerifyOtpRequestBody body);
  // عقد عملية تعيين كلمة المرور؛ يحدد المدخلات ونوع النتيجة دون تنفيذ الاتصال هنا.
  Future<ResetPasswordResponse> resetPassword(ResetPasswordRequestBody body);
}

// ينفّذ مسارات المصادقة عبر Dio؛ إعداد التطبيق الحالي يستخدم مصدر Firebase.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {

  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  // يرسل طلب تسجيل الدخول عبر HTTP ويحوّل رد JSON إلى النموذج المناسب.
  @override
  Future<LoginResponse> login(LoginRequestBody body) async {
    final response = await dio.post(
      ApiConstants.login,
      data: body.toJson(),
    );
    return LoginResponse.fromJson(response.data);
  }

  // يرسل طلب إنشاء الحساب عبر HTTP ويحوّل رد JSON إلى النموذج المناسب.
  @override
  Future<RegisterResponse> register(RegisterRequestBody body) async {
    final response = await dio.post(
      ApiConstants.register,
      data: body.toJson(),
    );
    return RegisterResponse.fromJson(response.data);
  }

  // يرسل طلب استعادة كلمة المرور عبر HTTP ويحوّل رد JSON إلى النموذج المناسب.
  @override
  Future<ForgotPasswordResponse> forgotPassword(
    ForgotPasswordRequestBody body,
  ) async {
    try {

      debugPrint('[forgot-password] sending request');
      final response = await dio.post(
        ApiConstants.forgotPassword,
        data: body.toJson(),
      );
      debugPrint('[forgot-password] status: ${response.statusCode}');
      debugPrint('[forgot-password] response: ${response.data}');
      return ForgotPasswordResponse.fromJson(response.data);
    } on DioException catch (error) {

      debugPrint('[forgot-password] dio error type: ${error.type}');
      debugPrint('[forgot-password] status: ${error.response?.statusCode}');
      debugPrint('[forgot-password] response: ${error.response?.data}');
      rethrow;
    }
  }

  // يرسل طلب التحقق من الرمز عبر HTTP ويحوّل رد JSON إلى النموذج المناسب.
  @override
  Future<VerifyOtpResponse> verifyOtp(VerifyOtpRequestBody body) async {
    final response = await dio.post(
      ApiConstants.verifyOtp,
      data: body.toJson(),
    );
    return VerifyOtpResponse.fromJson(response.data);
  }

  // يرسل طلب تعيين كلمة المرور عبر HTTP ويحوّل رد JSON إلى النموذج المناسب.
  @override
  Future<ResetPasswordResponse> resetPassword(
    ResetPasswordRequestBody body,
  ) async {

    final response = await dio.post(
      ApiConstants.resetPassword,
      data: body.toJson(),
    );
    return ResetPasswordResponse.fromJson(response.data);
  }
}
