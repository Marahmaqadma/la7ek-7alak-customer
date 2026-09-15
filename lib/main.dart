import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/routing/app_router.dart';

  // يهيّئ Flutter وFirebase قبل تشغيل واجهة التطبيق.
  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();

    // تهيئة خدمات Firebase قبل إنشاء المسارات التي تعتمد على المصادقة.
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  runApp(La7ek7alakApp(appRouter: AppRouter()));
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
          initialRoute: AppRouter.intro,
          onGenerateRoute: appRouter.onGenerateRoute,
        );
      },
    );
  }
}
