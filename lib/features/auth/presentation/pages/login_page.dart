import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/login_card.dart';
import '../widgets/login_header.dart';

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
                // Same width as the Figma frame.
                width: 360.w,

                child: Column(
                  children: [
                    const LoginHeader(),

                    LoginCard(
                      onForgotPassword: () {
                        // TODO: Go to forgot password page.
                      },

                      onCreateAccount: () {
                        // TODO: Go to register page.
                      },

                      onAdminLogin: () {
                        // TODO: Admin login.
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