import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

// بطاقة نوع الحساب التي تجمع الصورة والوصف وعلامة التحديد.
class UserTypeOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageAsset;
  final bool isSelected;
  final VoidCallback onTap;

  const UserTypeOptionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageAsset,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Padding(
        padding: EdgeInsets.only(top: 8.h),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 154.w,
              height: 243.h,
              padding: EdgeInsets.fromLTRB(12.w, 20.h, 12.w, 14.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? Color.alphaBlend(
                        AppColors.userTypeCardSelectedTint.withOpacity(0.2),
                        AppColors.white,
                      )
                    : AppColors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected
                      ? AppColors.introNavy
                      : AppColors.userTypeCardBorder,
                  width: isSelected ? 2.w : 1.w,
                ),
              ),
              child: Column(
                children: [
                  Image.asset(
                    imageAsset,
                    width: 88.w,
                    height: 88.w,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: double.infinity,
                    height: 25.h,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: AppTextStyles.userTypeCardTitle,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Expanded(
                    child: Center(
                      child: Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.userTypeCardSubtitle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                top: -3.h,
                left: -3.w,
                child: Container(
                  width: 22.w,
                  height: 22.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.introNavy,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 2.w),
                  ),
                  child: Icon(
                    Icons.check,
                    size: 13.sp,
                    color: AppColors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
