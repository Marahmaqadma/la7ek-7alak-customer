import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

// خيار في قائمة "حسابي": العنوان يمينًا والأيقونة يسارًا.
class ProfileOptionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  // لتمييز خيار مثل "تسجيل الخروج" باللون الأحمر.
  final Color? color;

  const ProfileOptionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final itemColor = color ?? AppColors.introNavy;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15.r),
          child: Container(
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.w),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      color: itemColor,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(icon, size: 20.sp, color: itemColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
