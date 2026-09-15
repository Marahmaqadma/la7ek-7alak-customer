import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

// عنوان التسجيل ووصف قصير يوضح للمستخدم هدف الشاشة.
class RegisterHeaderWidget extends StatelessWidget {
  const RegisterHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'إنشاء حساب جديد',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.introNavy,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'أنشئ حسابك الآن وابدأ باكتشاف أقوى العروض\nوالتخفيضات القريبة منك',
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
