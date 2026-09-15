import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';

// يعرض موقع المستخدم وعناصر ترويسة الصفحة الرئيسية.
class HomeHeader extends StatelessWidget {
  final String city;

  const HomeHeader({
    super.key,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const _HeaderIcon(icon: Icons.search),
            SizedBox(width: 10.w),
            const _HeaderIcon(icon: Icons.notifications_none),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'لحّق حالك',
                  style: TextStyle(
                    color: AppColors.orange,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
                SizedBox(height: 3.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: AppColors.orange,
                      size: 10.sp,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      city,
                      style: TextStyle(
                        color: AppColors.hint,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w500,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(width: 9.w),
            Container(
              width: 46.w,
              height: 46.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(23.r),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
        SizedBox(height: 18.h),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'متاجر قريبة منك',
            style: TextStyle(
              color: AppColors.darkBrown,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}

// أيقونة موحدة الشكل داخل ترويسة الرئيسية.
class _HeaderIcon extends StatelessWidget {
  final IconData icon;

  const _HeaderIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26.w,
      height: 26.w,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(
        icon,
        color: AppColors.darkBrown,
        size: 16.sp,
      ),
    );
  }
}
