import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

class AppTextStyles {
  // لحّق حالك
  static TextStyle get appTitle => TextStyle(
    fontFamily: 'Segoe UI',
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.darkBrown,
  );

  // لا تفوت العرض... الحق حالك
  static TextStyle get tagline => TextStyle(
    fontFamily: 'Segoe UI',
    fontSize: 10.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.orange,
  );

  // تسجيل الدخول
  static TextStyle get screenTitle => TextStyle(
    fontFamily: 'Segoe UI',
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.darkBrown,
  );

  // سجل دخولك للمتابعة
  static TextStyle get screenSubtitle => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
  );

  // البريد الإلكتروني / كلمة المرور
  static TextStyle get fieldLabel => TextStyle(
    fontFamily: 'Segoe UI',
    fontSize: 11.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.darkBrown,
  );

  // alaa@example.com
  static TextStyle get fieldHint => TextStyle(
    fontFamily: 'Segoe UI',
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.hint,
  );

  // نسيت كلمة المرور؟
  static TextStyle get linkText => TextStyle(
    fontFamily: 'Segoe UI',
    fontSize: 10.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.orange,
  );

  // اختر نوع الدخول
  static TextStyle get loginTypeLabel => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
  );

  // الدخول كمستهلك / الدخول كتاجر
  static TextStyle get loginTypeTitle => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 13.sp,
    fontWeight: FontWeight.w700,
  );

  // Text under login type
  static TextStyle get loginTypeSubtitle => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 9.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
  );

  // ليس لديك حساب؟
  static TextStyle get secondaryText => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
  );

  // إنشاء حساب جديد
  static TextStyle get actionText => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 11.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.selectedOrange,
  );

  // الدخول ك أدمن
  static TextStyle get adminButton => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 10.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.merchantBrown,
  );
}