import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/data/datasources/auth_backend_data_source.dart';
import '../../features/auth/data/datasources/auth_firebase_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/forgot_password/forgot_password_cubit.dart';
import '../../features/auth/presentation/cubit/login/login_cubit.dart';
import '../../features/auth/presentation/cubit/register/register_cubit.dart';
import '../../features/auth/presentation/cubit/cities/cities_cubit.dart';
import '../../features/auth/presentation/cubit/reset_password/reset_password_cubit.dart';
import '../../features/auth/presentation/pages/choose_user_type_page.dart';
import '../../features/auth/presentation/pages/login_credentials_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/auth/presentation/pages/send_verification_code_page.dart';
import '../../features/auth/presentation/widgets/login_type_card.dart'
    show LoginType;
import '../../features/customer/presentation/cubit/home_cubit/home_cubit.dart';
import '../../features/customer/presentation/cubit/account_settings_cubit/account_settings_cubit.dart';
import '../../features/customer/presentation/cubit/followers_cubit/followers_cubit.dart';
import '../../features/customer/presentation/cubit/support_cubit/support_cubit.dart';
import '../../features/customer/presentation/cubit/stores_map_cubit/stores_map_cubit.dart';
import '../../features/customer/presentation/pages/stores_map_page.dart';
import '../../features/customer/presentation/pages/account_settings_page.dart';
import '../../features/customer/presentation/pages/help_support_page.dart';
import '../../features/customer/presentation/pages/profile_page.dart';
import '../../features/customer/presentation/cubit/notifications_cubit/notifications_cubit.dart';
import '../../features/customer/presentation/pages/notifications_page.dart';
import '../../features/customer/presentation/cubit/store_profile_cubit/store_profile_cubit.dart';
import '../../features/customer/presentation/pages/followers_page.dart';
import '../../features/customer/presentation/pages/home_page.dart';
import '../../features/customer/presentation/pages/store_profile_page.dart';
import '../../features/auth/presentation/pages/splash_screen.dart';
import '../../features/auth/presentation/cubit/splash/splash_cubit.dart';
import '../../features/auth/presentation/pages/location_picker_page.dart';
import '../../features/auth/presentation/cubit/location_picker/location_picker_cubit.dart';
import '../../features/intro/presentation/pages/intro_page.dart';
import '../services/storage_service.dart';
import '../../features/customer/data/datasources/customer_remote_data_source.dart';
import '../../features/customer/data/repositories/customer_repository_impl.dart';
import '../../features/customer/domain/repositories/customer_repository.dart';
import '../../features/customer/presentation/cubit/interests_cubit/interests_cubit.dart';
import '../../features/customer/presentation/pages/interests_page.dart';
import '../network/dio_factory.dart';

// يربط أسماء المسارات بالشاشات ويزوّد شاشات المصادقة بمستودع البيانات.
class AppRouter {
  late AuthRepository authRepository;
  late CustomerRepository customerRepository;

  AppRouter({
    AuthRepository? authRepository,
    CustomerRepository? customerRepository,
  }) {
    const storageService = StorageService();
    final dio = DioFactory(storageService).createDio();

    this.authRepository = authRepository ??
        AuthRepositoryImpl(
          AuthFirebaseDataSourceImpl(),
          storageService: storageService,
          backendDataSource: AuthBackendDataSource(dio),
        );

    this.customerRepository = customerRepository ??
        CustomerRepositoryImpl(CustomerRemoteDataSource(dio));
  }

  static const String splash = '/splash';
  static const String intro = '/intro';
  static const String login = '/login';
  static const String loginCredentials = '/login-credentials';
  static const String register = '/register';
  static const String home = '/home';
  static const String sellerHome = '/seller-home';
  static const String sendVerificationCode = '/send-verification-code';
  static const String resetPassword = '/reset-password';
  static const String interests = '/interests';
  static const String storeProfile = '/store-profile';
  static const String followers = '/followers';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String accountSettings = '/account-settings';
  static const String helpSupport = '/help-support';
  static const String storesMap = '/stores-map';
  static const String locationPicker = '/location-picker';

  // ينشئ الشاشة المطلوبة ويهيّئ مدير حالتها عند الحاجة.
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // بداية التطبيق: فيديو اللوجو ثم شاشة الترحيب.
      case splash:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) =>
                SplashCubit(authRepository)..checkSession(),
            child: const SplashScreen(),
          ),
        );
      case intro:
        return MaterialPageRoute(
          builder: (_) => const IntroPage(),
        );
      // رئيسية الزبون. بدون أنيميشن لأنها تُفتح أيضًا من شريط التنقل كتبويب.
      case home:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => BlocProvider(
            create: (BuildContext context) =>
                HomeCubit(customerRepository)..loadAll(),
            child: const HomePage(),
          ),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
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
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (BuildContext context) => RegisterCubit(authRepository),
              ),
              BlocProvider(
                create: (BuildContext context) =>
                    CitiesCubit(authRepository)..load(),
              ),
            ],
            // التسجيل للزبائن فقط؛ حسابات التجار ينشئها الأدمن.
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
      case interests:
        {
          final isOnboarding = settings.arguments as bool? ?? false;
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (BuildContext context) => InterestsCubit(
                customerRepository,
                isOnboarding: isOnboarding,
              )..loadInterests(),
              child: const InterestsPage(),
            ),
          );
        }
      // المتاجر المتابَعة. بدون أنيميشن لأنها تبويب في شريط التنقل.
      case followers:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => BlocProvider(
            create: (BuildContext context) =>
                FollowersCubit(customerRepository)..load(),
            child: const FollowersPage(),
          ),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        );
      // الإشعارات. بدون أنيميشن لأنها تبويب في شريط التنقل.
      case notifications:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => BlocProvider(
            create: (BuildContext context) =>
                NotificationsCubit(customerRepository)..load(),
            child: const NotificationsScreen(),
          ),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        );
      // "حسابي": الاسم من الإعدادات. بدون أنيميشن لأنها تبويب في شريط التنقل.
      case profile:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => BlocProvider(
            create: (BuildContext context) =>
                AccountSettingsCubit(customerRepository)..load(),
            child: ProfilePage(
              onLogout: () async {
                await authRepository.logout();
              },
            ),
          ),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        );
      case accountSettings:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (BuildContext context) =>
                AccountSettingsCubit(customerRepository)..load(),
            child: const AccountSettingsPage(),
          ),
        );
      case helpSupport:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (BuildContext context) => SupportCubit(customerRepository),
            child: const HelpAndSupportScreen(),
          ),
        );
      // اختيار الموقع عند التسجيل؛ arguments = النقطة السابقة (اختياري).
      // ترجع النقطة المؤكدة بـ pop.
      case locationPicker:
        {
          final initial = settings.arguments as PickedLocation?;
          return MaterialPageRoute<PickedLocation>(
            settings: settings,
            builder: (_) => BlocProvider(
              create: (BuildContext context) => LocationPickerCubit(
                initialLatitude: initial?.latitude,
                initialLongitude: initial?.longitude,
              ),
              child: const LocationPickerPage(),
            ),
          );
        }
      // خريطة المتاجر؛ المتاجر تُحمّل عند جاهزية الخريطة حسب حدودها،
      // ونطلب موقع الزبون فورًا لنقرّب على المتاجر القريبة منه.
      case storesMap:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (BuildContext context) => StoresMapCubit(customerRepository)
              ..loadCategories()
              ..locate(),
            child: const StoresMapPage(),
          ),
        );
      // صفحة متجر؛ arguments = رقم المتجر (String).
      case storeProfile:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (BuildContext context) => StoreProfileCubit(
              customerRepository,
              storeId: settings.arguments as String,
            )..load(),
            child: const StoreProfilePage(),
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
