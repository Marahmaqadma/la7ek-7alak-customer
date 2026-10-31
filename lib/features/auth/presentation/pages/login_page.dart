import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/login_card.dart';
import '../widgets/login_header.dart';

// واجهة الدخول البديلة المبنية من عنوان وبطاقة نموذج.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: 360.w,
                child: Column(
                  children: [
                    const LoginHeader(),
                    LoginCard(
                      onForgotPassword: () {
                        // هذا الزر غير مربوط بالتنقل في الواجهة البديلة حاليًا.
                      },
                      onCreateAccount: () {
                        // فتح التسجيل غير موصول في هذه الواجهة البديلة.
                      },
                      onAdminLogin: () {
                        // دخول المسؤول غير منفّذ في هذه الواجهة.
                      },
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
