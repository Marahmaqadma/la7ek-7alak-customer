import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/forgot_password/forgot_password_cubit.dart';
import '../../features/auth/presentation/cubit/login/login_cubit.dart';
import '../../features/auth/presentation/cubit/register/register_cubit.dart';
import '../../features/auth/presentation/cubit/reset_password/reset_password_cubit.dart';
import '../../features/auth/presentation/cubit/verify_otp/verify_otp_cubit.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/auth/presentation/pages/send_verification_code_page.dart';
import '../network/dio_factory.dart';
import '../services/storage_service.dart';

class AppRouter {
  late AuthRepository authRepository;

  AppRouter() {
    const storageService = StorageService();
    final dio = DioFactory(storageService).createDio();
    authRepository = AuthRepositoryImpl(
      AuthRemoteDataSourceImpl(dio),
      storageService: storageService,
    );
  }

  static const String login = '/login';
  static const String register = '/register';
  static const String sendVerificationCode = '/send-verification-code';
  static const String resetPassword = '/reset-password';

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) => LoginCubit(authRepository),
            child: const LoginPage(),
          ),
        );
      case register:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) => RegisterCubit(authRepository),
            child: const RegisterPage(),
          ),
        );
      case sendVerificationCode:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (BuildContext context) =>
                    ForgotPasswordCubit(authRepository),
              ),
              BlocProvider(
                create: (BuildContext context) =>
                    VerifyOtpCubit(authRepository),
              ),
            ],
            child: const SendVerificationCodePage(),
          ),
        );
      case resetPassword:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) =>
                ResetPasswordCubit(authRepository),
            child: ResetPasswordPage(
              email: settings.arguments as String? ?? '',
            ),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
