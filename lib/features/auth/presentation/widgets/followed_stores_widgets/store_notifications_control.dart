import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

class StoreNotificationsControl extends StatelessWidget {
  const StoreNotificationsControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // الأزرار بالترتيب المطابق للفيجما تماماً: إيقاف (على اليمين قليلاً) ثم تفعيل (إلى يسارها)
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.red.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: Icon(Icons.notifications_off_outlined, size: 12.sp, color: Colors.red),
                label: Text(
                  'إيقاف',
                  style: TextStyle(fontSize: 11.sp, color: Colors.red),
                ),
              ),
              SizedBox(width: 6.w),
              ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE2F4EC),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: Icon(Icons.notifications_active, size: 12.sp, color: const Color(0xFF27AE60)),
                label: Text(
                  'تفعيل',
                  style: TextStyle(fontSize: 11.sp, color: const Color(0xFF27AE60)),
                ),
              ),
            ],
          ),
        ),

        // نص التحكم بالتنبيهات
        Text(
          'التحكم بالتنبيهات 🔔',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBrown,
          ),
        ),
      ],
    );
  }
}
