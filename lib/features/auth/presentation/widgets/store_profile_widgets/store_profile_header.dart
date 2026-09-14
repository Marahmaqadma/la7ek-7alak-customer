import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

class StoreProfileHeader extends StatelessWidget {
  const StoreProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'حساب المتجر',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.orange,
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.storefront_rounded,
              color: AppColors.orange,
              size: 22.sp,
            ),
          ],
        ),
      ),
    );
  }
}