import 'package:dartz/dartz.dart';
import '../../../../core/error/error_handler.dart'; // تأكدي من مسار الـ error handler لديكِ
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
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<ErrorHandler, LoginResponse>> login(
      LoginRequestBody loginRequestBody) async {
    try {
      // 1. جلب الاستجابة من الـ Remote Data Source (تم تعديل الاسم هنا ليطابق remoteDataSource)
      final response = await remoteDataSource.login(loginRequestBody);

      // 2. التحقق من وجود التوكن وحفظه في التخزين الآمن
      if (response.token.isNotEmpty) {
        // await SecureStorageHelper.setToken(response.token);
      }
      {
        // تأكدي من تفعيل خدمة التخزين لديكِ إن كنتِ تستخدمين SecureStorageHelper
        // await SecureStorageHelper.setToken(response.token!);
      }

      // 3. إرجاع النتيجة بنجاح
      return Right(response);
    } catch (error) {
      // 4. في حال حدوث أي خطأ، يتم إرجاعه عبر الـ ErrorHandler
      return Left(ErrorHandler.handle(error));
    }
  }

// تطبيق دالة إنشاء الحساب
  @override
  Future<Either<ErrorHandler, RegisterResponse>> register(
      RegisterRequestBody body) async {
    try {
// 1. إرسال الطلب للـ Remote Data Source
      final response = await remoteDataSource.register(body);

// 2. يمكنك هنا حفظ التوكن إن وُجد في الاستجابة (حسب تصميم السيرفر لديكم)
// if (response.user?.token != null) { ... }

// 3. إرجاع النتيجة بنجاح
      return Right(response);
    } catch (error) {
// 4. معالجة الخطأ إن حدث
      return Left(ErrorHandler.handle(error));
    }
  }
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