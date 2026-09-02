import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

enum LoginType {
  consumer,
  merchant,
}

class LoginTypeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const LoginTypeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color mainColor =
        isSelected ? AppColors.selectedOrange : AppColors.merchantBrown;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Exact Figma size.
        width: 129.w,
        height: 91.h,

        // No horizontal padding so the text gets enough width.
        padding: EdgeInsets.symmetric(
          vertical: 5.h,
        ),

        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.selectedCardBackground
              : AppColors.normalCardBackground,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: mainColor,
            width: isSelected ? 1.2.w : 1.w,
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28.sp,
              color: mainColor,
            ),

            SizedBox(height: 3.h),

            // FittedBox only shrinks the text if the device
            // doesn't have enough width.
            SizedBox(
              width: 121.w,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  maxLines: 1,
                  style: AppTextStyles.loginTypeTitle.copyWith(
                    color: mainColor,
                  ),
                ),
              ),
            ),

            SizedBox(height: 3.h),

            SizedBox(
              width: 121.w,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  subtitle,
                  maxLines: 1,
                  style: AppTextStyles.loginTypeSubtitle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
