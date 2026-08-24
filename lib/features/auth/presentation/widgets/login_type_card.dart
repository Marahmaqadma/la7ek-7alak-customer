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
    final mainColor =
    isSelected ? AppColors.selectedOrange : AppColors.merchantBrown;

    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: 129.w,
        height: 91.h,

        padding: EdgeInsets.symmetric(
          horizontal: 3.w,
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
              size: 26.sp,
              color: mainColor,
            ),

            SizedBox(height: 2.h),

            Text(
              title,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: AppTextStyles.loginTypeTitle.copyWith(
                color: mainColor,
              ),
            ),

            SizedBox(height: 2.h),

            Text(
              subtitle,
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.loginTypeSubtitle,
            ),
          ],
        ),
      ),
    );
  }
}