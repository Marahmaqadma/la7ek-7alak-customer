import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/constants/api_constants.dart';
import 'core/routing/app_router.dart';
import 'features/customer/presentation/navigation/customer_tabs.dart';
//import 'package:la7ek_7alak/features/auth/presentation/pages/interests_page.dart';
  // يهيّئ Flutter وFirebase قبل تشغيل واجهة التطبيق.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _wakeUpBackend();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(La7ek7alakApp(appRouter: AppRouter()));
}

// سيرفر Render المجاني ينام عند عدم الاستخدام ويحتاج حتى دقيقة ليصحو؛
// نوقظه بالخلفية عند فتح التطبيق حتى يكون جاهزًا عند تسجيل الدخول.
// لا ننتظر الرد، والفشل يُتجاهل لأنه لا يؤثر على عمل التطبيق.
void _wakeUpBackend() {
  Dio(BaseOptions(receiveTimeout: const Duration(seconds: 90)))
      .get(ApiConstants.baseUrl)
      .ignore();
}
// يضبط الخط وأبعاد التصميم والمسارات، ويبدأ بشاشة الترحيب.
class La7ek7alakApp extends StatelessWidget {
  final AppRouter appRouter;

  const La7ek7alakApp({
    super.key,
    required this.appRouter,

  });

  @override
  Widget build(BuildContext context) {
    // اعتماد أبعاد التصميم المرجعية لتكييف عناصر الواجهة مع حجم الجهاز.
    return ScreenUtilInit(
      designSize: const Size(360, 780),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(fontFamily: 'Tajawal'),
          debugShowCheckedModeBanner: false,
          // مؤقت للتجربة: فتح رئيسية الزبون مباشرة عبر الـ router (الذي ينشئ HomeCubit).
          // أرجعي AppRouter.intro عند الانتهاء.
          initialRoute: AppRouter.splash,
          onGenerateRoute: appRouter.onGenerateRoute,
          // يتتبع الشاشات المفتوحة حتى يرجع شريط التنقل لتبويب مفتوح بدل تكراره.
          navigatorObservers: [customerNavObserver],
        );
      },
    );
  }
}
