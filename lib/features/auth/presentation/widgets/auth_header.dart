import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_text_styles.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // The header follows the same width as the Figma frame.
      width: 360.w,
      height: 200.h,

      // Stack lets us place the logo and texts at exact Figma positions.
      child: Stack(
        children: [
          // App logo.
          Positioned(
            top: 32.h,
            left: 116.w,
            child: Image.asset(
              'assets/images/logo.png',
              width: 129.w,
              height: 129.h,

              // Keeps the full logo visible without cropping it.
              fit: BoxFit.contain,
            ),
          ),

          // Main app name.
          Positioned(
            top: 143.h,
            left: 0,
            right: 0,
            child: Text(
              'لحّق حالك',

              // left + right = 0 gives the Text the full width,
              // then center aligns it horizontally.
              textAlign: TextAlign.center,
              style: AppTextStyles.appTitle,
            ),
          ),

          // Short tagline shown below the app name.
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