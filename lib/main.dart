import 'package:flutter/material.dart';
//importing the  screenutil package
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/features/auth/presentation/pages/register_page.dart';
import 'package:la7ek_7alak/features/auth/presentation/pages/send_verification_code_page.dart';
import 'package:la7ek_7alak/features/auth/presentation/pages/store_profile_page.dart';
import 'features/auth/presentation/pages/followed_stores_page.dart';
import 'core/routing/app_router.dart';
import 'firebase_initializer.dart';
import 'features/auth/presentation/pages/welcome_page.dart';
import 'package:la7ek_7alak/features/auth/presentation/pages/splash_screen.dart';

/*void main() {
  runApp(La7ek7alakApp(appRouter: AppRouter()));
}*/
void main() async {
  await FirebaseInitializer.init();
  runApp(La7ek7alakApp(appRouter: AppRouter()));
}

class La7ek7alakApp extends StatelessWidget {
  final AppRouter appRouter;

  const La7ek7alakApp({
    super.key,
    required this.appRouter,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 780),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(fontFamily: 'Tajawal'),
          debugShowCheckedModeBanner: false,
            home: const SplashScreen()
          //initialRoute: AppRouter.register,
          //onGenerateRoute: appRouter.onGenerateRoute,
        );
      },
    );
  }
}
