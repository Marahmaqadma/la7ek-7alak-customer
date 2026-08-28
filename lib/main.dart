import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/routing/app_router.dart';
import 'package:la7ek_7alak/core/theme/app_theme.dart';

void main() {
  runApp(const La7ek7alakApp());
}

class La7ek7alakApp extends StatelessWidget {
  const La7ek7alakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // Our Figma frame size.
      designSize: const Size(360, 780),
      minTextAdapt: true,
      splitScreenMode: true,

      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(fontFamily: 'Tajawal'),
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,

          initialRoute: AppRouter.sendVerificationCode,
          onGenerateRoute: AppRouter.onGenerateRoute,

          // Prevents the phone's large system font setting
          // from destroying the Figma proportions.
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0),
              ),
              child: child!,
            );
          },
        );
      },
    );
  }
}