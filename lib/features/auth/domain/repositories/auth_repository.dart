import 'package:dartz/dartz.dart';
import '../../../../core/error/error_handler.dart';
import '../../data/models/login_request_body.dart';
import '../../data/models/register_request_body.dart';
import '../../data/models/login_response.dart';
import '../../data/models/register_response.dart';
import '../../data/models/forgot_password_request_body.dart';
import '../../data/models/forgot_password_response.dart';
import '../../data/models/verify_otp_request_body.dart';
import '../../data/models/verify_otp_response.dart';
import '../../data/models/reset_password_request_body.dart';
import '../../data/models/reset_password_response.dart';
abstract class AuthRepository {
  Future<Either<ErrorHandler, LoginResponse>> login(LoginRequestBody loginRequestBody);
  Future<Either<ErrorHandler, RegisterResponse>> register(RegisterRequestBody body);
  Future<Either<ErrorHandler, ForgotPasswordResponse>> forgotPassword(ForgotPasswordRequestBody body);
  Future<Either<ErrorHandler, VerifyOtpResponse>> verifyOtp(VerifyOtpRequestBody body);
  Future<Either<ErrorHandler, ResetPasswordResponse>> resetPassword(ResetPasswordRequestBody body);
}