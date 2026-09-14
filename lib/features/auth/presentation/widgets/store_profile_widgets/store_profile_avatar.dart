import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

class StoreProfileAvatar extends StatelessWidget {
  final File? imageFile;
  final String storeName;
  final String storeAddress;
  final VoidCallback onCameraTap;

  const StoreProfileAvatar({
    super.key,
    required this.imageFile,
    required this.storeName,
    required this.storeAddress,
    required this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.orange, width: 2),
              ),
              child: CircleAvatar(
                radius: 45.r,
                backgroundColor: AppColors.white, // خلفية بيضاء داخل الدائرة
                backgroundImage: imageFile != null ? FileImage(imageFile!) : null,
                child: imageFile == null
                    ? Icon(Icons.local_pizza_outlined, size: 40.sp, color: AppColors.orange)
                    : null,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: GestureDetector(
                onTap: onCameraTap,
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: const BoxDecoration(
                    color: AppColors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: 14.sp,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          storeName,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.darkBrown,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          storeAddress, // أو 'النصيرات - الشارع العام'
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.darkBrown, // تغيير اللون هنا للبني الغامق
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}