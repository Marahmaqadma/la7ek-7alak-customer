import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';
import 'package:la7ek_7alak/core/utils/helpers.dart';

import '../common/category_icon.dart';

// بطاقة متجر متابَع. من اليمين: الصورة، الاسم والوصف والوقت، ثم زر إلغاء المتابعة.
class FollowerCard extends StatelessWidget {
  final String storeName;
  final String subtitle;
  final String timeAgo;
  // بدون صورة تظهر أيقونة التصنيف، وإلا أيقونة متجر.
  final String? imageUrl;
  final String categoryIcon;
  final VoidCallback onStoreTap;
  final VoidCallback onUnfollowTap;

  const FollowerCard({
    super.key,
    required this.storeName,
    required this.subtitle,
    required this.timeAgo,
    required this.imageUrl,
    this.categoryIcon = '',
    required this.onStoreTap,
    required this.onUnfollowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.w),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onStoreTap,
            child: CircleAvatar(
              radius: 24.r,
              backgroundColor: const Color(0xFFF1F5F9),
              backgroundImage:
                  imageUrl == null ? null : imageProviderFor(imageUrl!),
              child: imageUrl != null
                  ? null
                  : categoryIcon.trim().isNotEmpty
                      ? CategoryIcon(
                          icon: categoryIcon,
                          size: 22.w,
                          color: AppColors.navy17244E,
                        )
                      : Icon(Icons.storefront_outlined,
                          size: 24.sp, color: AppColors.navy17244E),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onStoreTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    storeName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy17244E,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 10.sp,
                      color: const Color(0xFF8C7A70),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    timeAgo,
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 9.sp,
                      color: const Color(0xFFA3B894),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          TextButton(
            onPressed: onUnfollowTap,
            style: TextButton.styleFrom(
              backgroundColor: AppColors.navy17244E,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            ),
            child: Text(
              'إلغاء المتابعة',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 10.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
