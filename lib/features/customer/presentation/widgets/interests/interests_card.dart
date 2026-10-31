import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

import '../common/category_icon.dart';

class InterestCard extends StatelessWidget {
  final String title;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const InterestCard({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  // الـ SVG يُلوَّن بالبرتقالي كما في التصميم.
  Widget _buildIcon() =>
      CategoryIcon(icon: icon, size: 28.w, color: AppColors.orangeF58B1F);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.introNavy : AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.navy17365E : AppColors.greyD9D9D9,
            width: 1.5.w,
          ),
        ),
        child: Stack(
          children: [
            if (isSelected)
              // علامة الاختيار في الزاوية العلوية اليمنى كما في التصميم.
              PositionedDirectional(
                top: 10.h,
                start: 14.w,
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: const BoxDecoration(
                    color: AppColors.orangeF58B1F,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check,
                      size: 11.sp,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildIcon(),
                    SizedBox(height: 10.h),
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color:
                            isSelected ? AppColors.white : AppColors.navy17365E,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
