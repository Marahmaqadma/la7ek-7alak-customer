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

// ==========================================
// 1. العقد (Interface) الذي يحدد الفانكشنز المطلوبة
// ==========================================
abstract class AuthRemoteDataSource {
  // هذا interface يحدد كل API function نحتاجها في auth.
  // أي class يطبق هذا interface لازم يكتب نفس هذه الدوال.
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
  // dio هو المسؤول عن إرسال requests للسيرفر.
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  // يرسل email/password إلى endpoint login ويرجع LoginResponse من السيرفر.
  @override
  Future<LoginResponse> login(LoginRequestBody body) async {
    final response = await dio.post(
      ApiConstants.login,
      data: body.toJson(),
    );
    return LoginResponse.fromJson(response.data);
  }

  // يرسل بيانات إنشاء الحساب إلى endpoint register ويرجع رسالة/بيانات النجاح.
  @override
  Future<RegisterResponse> register(RegisterRequestBody body) async {
    final response = await dio.post(
      ApiConstants.register,
      data: body.toJson(),
    );
    return RegisterResponse.fromJson(response.data);
  }

  @override
  Future<ForgotPasswordResponse> forgotPassword(
    ForgotPasswordRequestBody body,
  ) async {
    try {
      // يرسل email فقط للسيرفر حتى السيرفر يولد OTP ويرسله بالبريد.
      // هذه logs مؤقتة ومحدودة لهذا الطلب حتى نعرف ماذا يرجع السيرفر أثناء التجربة.
      debugPrint('[forgot-password] sending request');
      final response = await dio.post(
        ApiConstants.forgotPassword,
        data: body.toJson(),
      );
      debugPrint('[forgot-password] status: ${response.statusCode}');
      debugPrint('[forgot-password] response: ${response.data}');
      return ForgotPasswordResponse.fromJson(response.data);
    } on DioException catch (error) {
      // إذا فشل الطلب، اطبع نوع الخطأ والرد بدون طباعة الإيميل أو بيانات حساسة.
      debugPrint('[forgot-password] dio error type: ${error.type}');
      debugPrint('[forgot-password] status: ${error.response?.statusCode}');
      debugPrint('[forgot-password] response: ${error.response?.data}');
      rethrow;
    }
  }

  // يرسل email مع OTP المكون من 6 أرقام حتى السيرفر يتأكد أن الرمز صحيح.
  @override
  Future<VerifyOtpResponse> verifyOtp(VerifyOtpRequestBody body) async {
    final response = await dio.post(
      ApiConstants.verifyOtp,
      data: body.toJson(),
    );
    return VerifyOtpResponse.fromJson(response.data);
  }

  @override
  Future<ResetPasswordResponse> resetPassword(
    ResetPasswordRequestBody body,
  ) async {
    // بعد نجاح OTP، هذه الدالة ترسل email وكلمة المرور الجديدة للسيرفر.
    final response = await dio.post(
      ApiConstants.resetPassword,
      data: body.toJson(),
    );
    return ResetPasswordResponse.fromJson(response.data);
  }
}
