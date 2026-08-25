import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/send_verification_code_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';

class AppRouter {
  static const String login = '/login';
  static const String register = '/register';
  static const String sendVerificationCode = '/send-verification-code';
  static const String resetPassword = '/reset-password';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case sendVerificationCode:
        return MaterialPageRoute(builder: (_) => const SendVerificationCodePage());
      case resetPassword:
        return MaterialPageRoute(builder: (_) => const ResetPasswordPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}