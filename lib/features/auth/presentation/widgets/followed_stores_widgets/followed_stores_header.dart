import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

class FollowedStoresHeader extends StatelessWidget {
  final VoidCallback? onSearchPressed; // دالة البحث

  const FollowedStoresHeader({
    super.key,
    this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundColor: AppColors.white,
                    child: IconButton(
                      icon: Icon(Icons.search, color: AppColors.darkBrown),
                      onPressed: onSearchPressed, // تفعيل زر البحث
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // أيقونة الإشعارات مع النقطة البرتقالية فوقها
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 20.r,
                        backgroundColor: AppColors.white,
                        child: IconButton(
                          icon: Icon(Icons.notifications_none, color: AppColors.darkBrown),
                          onPressed: () {},
                        ),
                      ),
                      Positioned(
                        top: 6.h,
                        right: 6.w,
                        child: Container(
                          width: 8.w,
                          height: 8.h,
                          decoration: const BoxDecoration(
                            color: AppColors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'المتاجر المُتابَعة',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBrown,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'إدارة مفضلاتك',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.orange,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(Icons.star_border, size: 14.sp, color: AppColors.orange),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Align(
            alignment: Alignment.centerRight,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                'متاجر تتابعها الآن 👇',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkBrown,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}