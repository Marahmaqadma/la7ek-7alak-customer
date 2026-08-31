import 'package:dartz/dartz.dart';
import '../../../../core/error/error_handler.dart'; // تأكدي من مسار الـ error handler لديكِ
import '../../../../core/services/storage_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/register_response.dart';
import '../models/login_request_body.dart';
import '../models/register_request_body.dart';
import '../models/login_response.dart';
import '../models/forgot_password_request_body.dart';
import '../models/forgot_password_response.dart';
import '../models/verify_otp_request_body.dart';
import '../models/verify_otp_response.dart';
import '../models/reset_password_request_body.dart';
import '../models/reset_password_response.dart';

class AuthRepositoryImpl implements AuthRepository {
  // remoteDataSource هو المكان الذي ينفذ طلبات API الفعلية.
  final AuthRemoteDataSource remoteDataSource;

  // storageService اختياري حتى نحفظ token بعد login بدون ما نكسر tests أو الاستخدامات القديمة.
  final StorageService? storageService;

  AuthRepositoryImpl(
    this.remoteDataSource, {
    this.storageService,
  });

  @override
  Future<Either<ErrorHandler, LoginResponse>> login(
      LoginRequestBody loginRequestBody) async {
    try {
      // أرسل بيانات تسجيل الدخول للسيرفر وانتظر الرد.
      final response = await remoteDataSource.login(loginRequestBody);

      // إذا السيرفر رجع token، احفظه لاستخدامه في الطلبات القادمة.
      if (response.token.isNotEmpty) {
        await storageService?.saveToken(response.token);
      }

      // Right يعني العملية نجحت وسنرسل response للـ Cubit.
      return Right(response);
    } catch (error) {
      // Left يعني العملية فشلت وسنرسل رسالة خطأ مفهومة للـ Cubit.
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ErrorHandler, RegisterResponse>> register(
      RegisterRequestBody body) async {
    try {
      // أرسل بيانات إنشاء الحساب للسيرفر.
      final response = await remoteDataSource.register(body);

      // رجع النتيجة للـ Cubit كنجاح.
      return Right(response);
    } catch (error) {
      // رجع الخطأ للـ Cubit برسالة مناسبة.
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ErrorHandler, ForgotPasswordResponse>> forgotPassword(
      ForgotPasswordRequestBody body) async {
    try {
      // أرسل email فقط حتى السيرفر يرسل OTP للبريد.
      final response = await remoteDataSource.forgotPassword(body);
      return Right(response);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ErrorHandler, VerifyOtpResponse>> verifyOtp(
      VerifyOtpRequestBody body) async {
    try {
      // أرسل email والـ OTP حتى السيرفر يتأكد من الرمز.
      final response = await remoteDataSource.verifyOtp(body);
      return Right(response);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ErrorHandler, ResetPasswordResponse>> resetPassword(
      ResetPasswordRequestBody body) async {
    try {
      // أرسل كلمة المرور الجديدة بعد نجاح التحقق من OTP.
      final response = await remoteDataSource.resetPassword(body);
      return Right(response);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
}
