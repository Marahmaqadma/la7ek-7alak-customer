import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:la7ek_7alak/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:la7ek_7alak/features/auth/data/models/login/login_request_body.dart';
import 'package:la7ek_7alak/features/auth/data/models/register/register_request_body.dart';
import 'package:la7ek_7alak/features/auth/data/models/forgot_password/forgot_password_request_body.dart';
import 'package:la7ek_7alak/features/auth/data/models/forgot_password/forgot_password_response.dart';
import 'package:la7ek_7alak/features/auth/data/models/verify_otp/verify_otp_request_body.dart';
import 'package:la7ek_7alak/features/auth/data/models/verify_otp/verify_otp_response.dart';
import 'package:la7ek_7alak/features/auth/data/models/reset_password/reset_password_request_body.dart';
import 'package:la7ek_7alak/features/auth/data/models/reset_password/reset_password_response.dart';
import 'package:la7ek_7alak/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:la7ek_7alak/features/auth/data/models/login/login_response.dart'
    as login_model;
import 'package:la7ek_7alak/features/auth/data/models/register/register_response.dart'
    as register_model;

@GenerateMocks([AuthRemoteDataSource])
import 'auth_remote_data_source_test.mocks.dart';

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(mockRemoteDataSource);
  });

  group('AuthRepositoryImpl Unit Tests', () {
    final tLoginRequestBody = LoginRequestBody(
      email: 'admin@gmail.com',
      password: '123456',
    );

    final tRegisterRequestBody = RegisterRequestBody(
        fullName: 'Alaa',
        email: 'alaaa@gmail.com',
        password: 'password123',
        role: 'customer',
        phone: '0598842514');

    final tLoginResponse = login_model.LoginResponse(
      token: '12345',
      message: 'Success',
      user: login_model.UserData(
          id: '2', email: 'admin@gmail.com', role: 'admin', fullName: 'admin'),
    );

    final tRegisterResponse = register_model.RegisterResponse(
      message: 'Registered Successfully',
      user: register_model.UserData(
        id: '1',
        email: 'alaaa@gmail.com',
        role: 'customer',
        fullName: 'Alaa',
      ),
    );

    final tForgotBody = ForgotPasswordRequestBody(email: 'test@gmail.com');
    final tForgotResponse = ForgotPasswordResponse(message: 'Code sent');

    final tVerifyBody =
        VerifyOtpRequestBody(email: 'test@gmail.com', otp: '1234');
    final tVerifyResponse = VerifyOtpResponse(message: 'Verified');

    final tResetBody = ResetPasswordRequestBody(
        email: 'test@gmail.com', newPassword: 'new12345');
    final tResetResponse = ResetPasswordResponse(message: 'Password updated');

    // 1. تيست نجاح تسجيل الدخول
    test('should return LoginResponse when login is successful', () async {
      when(mockRemoteDataSource.login(any))
          .thenAnswer((_) async => tLoginResponse);

      final result = await repository.login(tLoginRequestBody);

      expect(result, equals(Right(tLoginResponse)));
      verify(mockRemoteDataSource.login(tLoginRequestBody));
    });

    // 2. تيست فشل تسجيل الدخول
    test('should return ErrorHandler when login fails', () async {
      when(mockRemoteDataSource.login(any))
          .thenThrow(Exception('Server Error'));

      final result = await repository.login(tLoginRequestBody);

      expect(result.isLeft(), true);
      verify(mockRemoteDataSource.login(tLoginRequestBody));
    });

    // 3. تيست نجاح إنشاء الحساب
    test('should return RegisterResponse when register is successful',
        () async {
      when(mockRemoteDataSource.register(any))
          .thenAnswer((_) async => tRegisterResponse);

      final result = await repository.register(tRegisterRequestBody);

      expect(result, equals(Right(tRegisterResponse)));
      verify(mockRemoteDataSource.register(tRegisterRequestBody));
    });

    // 4. تيست فشل إنشاء الحساب
    test('should return ErrorHandler when register fails', () async {
      when(mockRemoteDataSource.register(any))
          .thenThrow(Exception('Email already in use'));

      final result = await repository.register(tRegisterRequestBody);

      expect(result.isLeft(), true);
      verify(mockRemoteDataSource.register(tRegisterRequestBody));
    });

    // 5. تيست نجاح Forgot Password
    test(
        'should return ForgotPasswordResponse when forgotPassword is successful',
        () async {
      when(mockRemoteDataSource.forgotPassword(any))
          .thenAnswer((_) async => tForgotResponse);

      final result = await repository.forgotPassword(tForgotBody);

      expect(result, equals(Right(tForgotResponse)));
      verify(mockRemoteDataSource.forgotPassword(tForgotBody));
    });

    // 6. تيست نجاح Verify OTP
    test('should return VerifyOtpResponse when verifyOtp is successful',
        () async {
      when(mockRemoteDataSource.verifyOtp(any))
          .thenAnswer((_) async => tVerifyResponse);

      final result = await repository.verifyOtp(tVerifyBody);

      expect(result, equals(Right(tVerifyResponse)));
      verify(mockRemoteDataSource.verifyOtp(tVerifyBody));
    });

    // 7. تيست نجاح Reset Password
    test('should return ResetPasswordResponse when resetPassword is successful',
        () async {
      when(mockRemoteDataSource.resetPassword(any))
          .thenAnswer((_) async => tResetResponse);

      final result = await repository.resetPassword(tResetBody);

      expect(result, equals(Right(tResetResponse)));
      verify(mockRemoteDataSource.resetPassword(tResetBody));
    });
  });
}
