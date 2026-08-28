import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/send_verification_code_page.dart';

class AppRouter {
  static const String login = '/login';
  static const String sendVerificationCode = '/send-verification-code';
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );

        case sendVerificationCode:
      return MaterialPageRoute(
        builder: (_) => const SendVerificationCodePage(),
      );

      default:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );
    }
  }
}