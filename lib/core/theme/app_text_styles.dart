import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();
//login screen
  // "لحّق حالك"
  static TextStyle get appTitle => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    height: 1,
    color: AppColors.darkBrown,
  );

  // "لا تفوت العرض... الحق حالك"
  static TextStyle get tagline => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 10.sp,
    fontWeight: FontWeight.w700,
    height: 1,
    color: AppColors.orange,
  );

  // "تسجيل الدخول"
  static TextStyle get screenTitle => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    height: 1,
    color: AppColors.darkBrown,
  );

  // "سجل دخولك للمتابعة"
  static TextStyle get screenSubtitle => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    height: 1,
    color: AppColors.grey,
  );

  // Labels مثل البريد الإلكتروني / كلمة المرور
  static TextStyle get fieldLabel => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 11.sp,
    fontWeight: FontWeight.w700,
    height: 1,
    color: AppColors.darkBrown,
  );

  // Hint داخل TextField
  static TextStyle get fieldHint => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    height: 1,
    color: AppColors.hint,
  );

  // "نسيت كلمة المرور؟"
  static TextStyle get linkText => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 10.sp,
    fontWeight: FontWeight.w700,
    height: 1,
    color: AppColors.orange,
  );

  // "اختر نوع الدخول"
  static TextStyle get loginTypeLabel => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    height: 1,
    color: AppColors.grey,
  );

  // "الدخول كمستهلك" / "الدخول كتاجر"
  static TextStyle get loginTypeTitle => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 13.sp,
    fontWeight: FontWeight.w700,
    height: 1,
    color: AppColors.darkBrown,
  );

  // النص الصغير داخل بطاقات نوع الدخول
  static TextStyle get loginTypeSubtitle => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 9.sp,
    fontWeight: FontWeight.w400,
    height: 1,
    color: AppColors.grey,
  );

  // "ليس لديك حساب؟"
  static TextStyle get secondaryText => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    height: 1,
    color: AppColors.grey,
  );

  // "إنشاء حساب جديد"
  static TextStyle get actionText => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 11.sp,
    fontWeight: FontWeight.w700,
    height: 1,
    color: AppColors.selectedOrange,
  );

  // Admin button
  static TextStyle get adminButton => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 10.sp,
    fontWeight: FontWeight.w700,
    height: 1,
    color: AppColors.merchantBrown,
  );

  //verification code screen

  // Large page title
  static TextStyle get pageTitleLarge => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
    height: 1,
    color: AppColors.darkBrown,
  );

  // Small colored page subtitle
  static TextStyle get pageSubtitleSmall => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    height: 1,
    color: AppColors.orange,
  );

  // Small bold form label
  static TextStyle get formLabelSmall => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 10.sp,
    fontWeight: FontWeight.w700,
    height: 1,
    color: AppColors.darkBrown,
  );

  // Underlined field text
  static TextStyle get underlinedFieldText => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    height: 1,
    decoration: TextDecoration.underline,
    color: AppColors.hint,
  );

  // Verification / PIN code digits
  static TextStyle get codeDigit => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
    height: 1,
    color: AppColors.darkBrown,
  );

  // Muted helper caption
  static TextStyle get captionMuted => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 9.sp,
    fontWeight: FontWeight.w400,
    height: 1,
    color: AppColors.mutedText,
  );

  // Highlighted helper caption
  static TextStyle get captionHighlight => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 9.sp,
    fontWeight: FontWeight.w700,
    height: 1,
    color: AppColors.orange,
  );

  // Small filled button text
  static TextStyle get buttonTextSmall => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 12.sp,
    fontWeight: FontWeight.w700,
    height: 1,
    color: AppColors.white,
  );
}
