import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

class AppTextStyles {
  // Application title
  static TextStyle get appTitle => TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.darkBrown,
  );

  // Application tagline
  static TextStyle get tagline => TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.orange,
  );

  // Screen title
  static TextStyle get screenTitle => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.darkBrown,
  );

  // Description below screen title
  static TextStyle get description => TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
  );

  // labels for the fields
  static TextStyle get fieldLabel => TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.darkBrown,
  );

  // Text / hint inside the fields
  static TextStyle get fieldHint => TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.hint,
  );

  // "نسيت كلمة المرور؟"
  static TextStyle get linkText => TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.orange,
  );

  // Text inside orange buttons
  static TextStyle get buttonText => TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  // Links
  static TextStyle get secondaryText => TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.darkBrown,
  );

  // Action buttons
  static TextStyle get actionText => TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.orange,
  );
}