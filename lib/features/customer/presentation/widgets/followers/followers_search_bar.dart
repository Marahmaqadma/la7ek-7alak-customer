import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

// حقل البحث في المتاجر المتابَعة؛ النص يُرسل للخارج عند كل تغيير.
class FollowersSearchBar extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;

  const FollowersSearchBar({super.key, required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.navy17244E, width: 1.w),
        ),
        alignment: Alignment.center,
        child: TextField(
          onChanged: onSearchChanged,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 12.sp,
            color: AppColors.navy17244E,
          ),
          decoration: InputDecoration(
            hintText: 'ابحث في المتاجر المتابعة...',
            hintStyle: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 12.sp,
              color: const Color(0xFF94A3B8),
            ),
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
          ),
        ),
      ),
    );
  }
}
