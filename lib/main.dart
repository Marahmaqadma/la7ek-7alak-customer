import 'package:flutter/material.dart';
//importing the  screenutil package
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/features/auth/presentation/pages/login_page.dart';
import 'package:la7ek_7alak/features/auth/presentation/pages/send_verification_code_page.dart';
import 'features/auth/presentation/pages/reset_password_page.dart';
import 'package:la7ek_7alak/features/auth/presentation/pages/register_page.dart';

void main() {
  runApp(const La7ek7alakApp());
}

class La7ek7alakApp  extends StatelessWidget {
  const La7ek7alakApp({super.key});

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
          home: const RegisterPage(),
        );
      },
    );
  }
}

