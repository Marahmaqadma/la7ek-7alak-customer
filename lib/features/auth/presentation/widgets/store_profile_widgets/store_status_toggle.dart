import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

class StoreStatusToggle extends StatelessWidget {
  final bool isActive;
  final ValueChanged<bool> onStatusChanged;

  const StoreStatusToggle({
    super.key,
    required this.isActive,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // أزرار التبديل (نشط / غير نشط)
          Row(
            children: [
              // زر نشط
              GestureDetector(
                onTap: () => onStatusChanged(true),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.green.withOpacity(0.15) : Colors.transparent,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isActive ? Colors.green : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'نشط',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.green : AppColors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              // زر غير نشط
              GestureDetector(
                onTap: () => onStatusChanged(false),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: !isActive ? Colors.red.withOpacity(0.15) : Colors.transparent,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: !isActive ? Colors.red : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'غير نشط',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: !isActive ? Colors.red : AppColors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // تسمية الحقل
          Text(
            'حالة المتجر في التطبيق',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBrown,
            ),
          ),
        ],
      ),
    );
  }
}