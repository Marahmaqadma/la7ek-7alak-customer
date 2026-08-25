import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_text_styles.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Figma frame width.
      width: 360.w,
      height: 210.h,

      child: Stack(
        children: [
          // Logo — exact Figma position and size.
          Positioned(
            top: 32.h,
            left: 116.w,
            child: Image.asset(
              'assets/images/logo.png',
              width: 129.w,
              height: 129.h,
              fit: BoxFit.contain,
            ),
          ),

          // App title.
          Positioned(
            top: 143.h,
            left: 0,
            right: 0,
            child: Text(
              'لحّق حالك',
              textAlign: TextAlign.center,
              style: AppTextStyles.appTitle,
            ),
          ),

          // Tagline.
          Positioned(
            top: 182.h,
            left: 0,
            right: 0,
            child: Text(
              'لا تفوت العرض... لحق حالك',
              textAlign: TextAlign.center,
              style: AppTextStyles.tagline,
            ),
          ),
        ],
      ),
    );
  }
}