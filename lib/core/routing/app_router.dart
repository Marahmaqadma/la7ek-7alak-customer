import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/data/datasources/auth_firebase_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/forgot_password/forgot_password_cubit.dart';
import '../../features/auth/presentation/cubit/login/login_cubit.dart';
import '../../features/auth/presentation/cubit/register/register_cubit.dart';
import '../../features/auth/presentation/cubit/reset_password/reset_password_cubit.dart';
import '../../features/auth/presentation/pages/choose_user_type_page.dart';
import '../../features/auth/presentation/pages/login_credentials_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/auth/presentation/pages/send_verification_code_page.dart';
import '../../features/auth/presentation/widgets/login_type_card.dart'
    show LoginType;
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/intro/presentation/pages/intro_page.dart';
import '../../features/seller_home/presentation/pages/seller_home_page.dart';
import '../services/storage_service.dart';

// يربط أسماء المسارات بالشاشات ويزوّد شاشات المصادقة بمستودع البيانات.
class AppRouter {
  late AuthRepository authRepository;

  // يقبل مستودعًا للاختبارات، ويستخدم Firebase والتخزين الآمن افتراضيًا.
  AppRouter({AuthRepository? authRepository}) {
    const storageService = StorageService();

    this.authRepository = authRepository ??
        AuthRepositoryImpl(
          AuthFirebaseDataSourceImpl(),
          storageService: storageService,
        );
  }

  static const String intro = '/intro';
  static const String login = '/login';
  static const String loginCredentials = '/login-credentials';
  static const String register = '/register';
  static const String home = '/home';
  static const String sellerHome = '/seller-home';
  static const String sendVerificationCode = '/send-verification-code';
  static const String resetPassword = '/reset-password';

  // ينشئ الشاشة المطلوبة ويهيّئ مدير حالتها عند الحاجة.
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // بداية التطبيق: شاشة الترحيب.
      case intro:
        return MaterialPageRoute(
          builder: (_) => const IntroPage(),
        );
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
        );
      case sellerHome:
        return MaterialPageRoute(
          builder: (_) => const SellerHomePage(),
        );
      // اختيار دور الحساب قبل إدخال بيانات الدخول.
      case login:
        return MaterialPageRoute(
          builder: (_) => const ChooseUserTypePage(),
        );
      // تمرير الدور المختار إلى نموذج الدخول، مع افتراض دور المستهلك إن غاب.
      case loginCredentials:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) => LoginCubit(authRepository),
            child: LoginCredentialsPage(
              loginType: settings.arguments as LoginType? ?? LoginType.consumer,
            ),
          ),
        );
      // توفير مدير حالة مستقل لطلب إنشاء الحساب.
      case register:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) => RegisterCubit(authRepository),
            child: const RegisterPage(),
          ),
        );
      // شاشة استعادة الحساب ترسل رابط بريد عبر Firebase.
      case sendVerificationCode:

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) =>
                ForgotPasswordCubit(authRepository),
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
