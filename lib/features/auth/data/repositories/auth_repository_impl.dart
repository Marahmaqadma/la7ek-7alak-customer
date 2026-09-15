import 'package:dartz/dartz.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/register/register_response.dart';
import '../models/login/login_request_body.dart';
import '../models/register/register_request_body.dart';
import '../models/login/login_response.dart';
import '../models/forgot_password/forgot_password_request_body.dart';
import '../models/forgot_password/forgot_password_response.dart';
import '../models/verify_otp/verify_otp_request_body.dart';
import '../models/verify_otp/verify_otp_response.dart';
import '../models/reset_password/reset_password_request_body.dart';
import '../models/reset_password/reset_password_response.dart';

// ينسّق طلبات المصادقة، ويحفظ رمز الدخول، ويحوّل الاستثناءات إلى نتائج فشل.
class AuthRepositoryImpl implements AuthRepository {

  final AuthRemoteDataSource remoteDataSource;

  final StorageService? storageService;

  AuthRepositoryImpl(
    this.remoteDataSource, {
    this.storageService,
  });

  // ينفّذ الدخول ويحفظ الرمز إن توفّر التخزين، ويعيد الخطأ عند تعذر أي خطوة.
  @override
  Future<Either<ErrorHandler, LoginResponse>> login(
      LoginRequestBody loginRequestBody) async {
    try {

      final response = await remoteDataSource.login(loginRequestBody);

      // حفظ الرمز اختياري عند توفير خدمة التخزين؛ تستخدم الاختبارات المستودع دونها.
      if (response.token.isNotEmpty) {
        await storageService?.saveToken(response.token);
      }

      return Right(response);
    } catch (error) {

      return Left(ErrorHandler.handle(error));
    }
  }

  // يمرر طلب إنشاء الحساب إلى مصدر البيانات ويعيد النتيجة أو رسالة الفشل.
  @override
  Future<Either<ErrorHandler, RegisterResponse>> register(
      RegisterRequestBody body) async {
    try {

      final response = await remoteDataSource.register(body);

      return Right(response);
    } catch (error) {

      return Left(ErrorHandler.handle(error));
    }
  }

  // يمرر طلب استعادة كلمة المرور إلى مصدر البيانات ويعيد النتيجة أو رسالة الفشل.
  @override
  Future<Either<ErrorHandler, ForgotPasswordResponse>> forgotPassword(
      ForgotPasswordRequestBody body) async {
    try {

      final response = await remoteDataSource.forgotPassword(body);
      return Right(response);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  // يمرر طلب التحقق من الرمز إلى مصدر البيانات ويعيد النتيجة أو رسالة الفشل.
  @override
  Future<Either<ErrorHandler, VerifyOtpResponse>> verifyOtp(
      VerifyOtpRequestBody body) async {
    try {

      final response = await remoteDataSource.verifyOtp(body);
      return Right(response);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  // يمرر طلب تعيين كلمة المرور إلى مصدر البيانات ويعيد النتيجة أو رسالة الفشل.
  @override
  Future<Either<ErrorHandler, ResetPasswordResponse>> resetPassword(
      ResetPasswordRequestBody body) async {
    try {

      final response = await remoteDataSource.resetPassword(body);
      return Right(response);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
}
