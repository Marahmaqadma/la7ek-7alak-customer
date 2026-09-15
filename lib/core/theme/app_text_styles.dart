import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

// أنماط النصوص المشتركة؛ تتكيف أحجام الخطوط مع أبعاد الشاشة.
class AppTextStyles {
  AppTextStyles._();

  // تنسيق اسم التطبيق.
  static TextStyle get appTitle => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    height: 1,
    color: AppColors.darkBrown,
  );

  // تنسيق العبارة التعريفية.
  static TextStyle get tagline => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 10.sp,
    fontWeight: FontWeight.w700,
    height: 1,
    color: AppColors.orange,
  );

  // تنسيق عنوان شاشة الدخول.
  static TextStyle get screenTitle => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    height: 1,
    color: AppColors.darkBrown,
  );

  // تنسيق وصف شاشة الدخول.
  static TextStyle get screenSubtitle => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    height: 1,
    color: AppColors.grey,
  );

  // تنسيق عنوان الحقل.
  static TextStyle get fieldLabel => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 11.sp,
    fontWeight: FontWeight.w700,
    height: 1,
    color: AppColors.darkBrown,
  );

  // تنسيق النص الإرشادي داخل الحقل.
  static TextStyle get fieldHint => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    height: 1,
    color: AppColors.hint,
  );

  // تنسيق روابط المساعدة.
  static TextStyle get linkText => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 10.sp,
    fontWeight: FontWeight.w700,
    height: 1,
    color: AppColors.orange,
  );

  // تنسيق عنوان اختيار الدور.
  static TextStyle get loginTypeLabel => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    height: 1,
    color: AppColors.grey,
  );

  // تنسيق عنوان بطاقة الدور.
  static TextStyle get loginTypeTitle => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 13.sp,
    fontWeight: FontWeight.w700,
    height: 1,
    color: AppColors.darkBrown,
  );

  // تنسيق وصف بطاقة الدور.
  static TextStyle get loginTypeSubtitle => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 9.sp,
    fontWeight: FontWeight.w400,
    height: 1,
    color: AppColors.grey,
  );

  // تنسيق النصوص الثانوية.
  static TextStyle get secondaryText => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    height: 1,
    color: AppColors.grey,
  );

  // تنسيق روابط الإجراءات.
  static TextStyle get actionText => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 11.sp,
    fontWeight: FontWeight.w700,
    height: 1,
    color: AppColors.selectedOrange,
  );

  // تنسيق زر دخول المسؤول.
  static TextStyle get adminButton => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 10.sp,
    fontWeight: FontWeight.w700,
    height: 1,
    color: AppColors.merchantBrown,
  );

  // تنسيق عنوان الصفحة الكبير.
  static TextStyle get pageTitleLarge => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
    height: 1,
    color: AppColors.darkBrown,
  );

  // تنسيق وصف الصفحة القصير.
  static TextStyle get pageSubtitleSmall => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    height: 1,
    color: AppColors.orange,
  );

  // تنسيق عنوان الحقل الصغير.
  static TextStyle get formLabelSmall => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 10.sp,
    fontWeight: FontWeight.w700,
    height: 1,
    color: AppColors.darkBrown,
  );

  // تنسيق النص ذي الخط السفلي.
  static TextStyle get underlinedFieldText => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    height: 1,
    decoration: TextDecoration.underline,
    color: AppColors.hint,
  );

  // تنسيق أرقام رمز التحقق.
  static TextStyle get codeDigit => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
    height: 1,
    color: AppColors.darkBrown,
  );

  // تنسيق النص المساعد الهادئ.
  static TextStyle get captionMuted => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 9.sp,
    fontWeight: FontWeight.w400,
    height: 1,
    color: AppColors.mutedText,
  );

  // تنسيق الجزء البارز من النص المساعد.
  static TextStyle get captionHighlight => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 9.sp,
    fontWeight: FontWeight.w700,
    height: 1,
    color: AppColors.orange,
  );

  // تنسيق نص الزر الصغير.
  static TextStyle get buttonTextSmall => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 12.sp,
    fontWeight: FontWeight.w700,
    height: 1,
    color: AppColors.white,
  );

  // تنسيق عنوان الترحيب.
  static TextStyle get introTitle => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
    color: AppColors.darkBrown,
  );

  // تنسيق وصف الترحيب.
  static TextStyle get introSubtitle => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.introSubtitleGrey,
  );

  // تنسيق زر شاشة الترحيب.
  static TextStyle get introButtonText => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    height: 1,
    color: AppColors.white,
  );

  // تنسيق عنوان اختيار الحساب.
  static TextStyle get userTypeTitle => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.introNavy,
  );

  // تنسيق وصف اختيار الحساب.
  static TextStyle get userTypeSubtitle => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.introSubtitleGrey,
  );

  // تنسيق عنوان بطاقة الحساب.
  static TextStyle get userTypeCardTitle => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 15.sp,
    fontWeight: FontWeight.w500,
    height: 1.2,
    color: AppColors.darkBrown,
  );

  // تنسيق وصف بطاقة الحساب.
  static TextStyle get userTypeCardSubtitle => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: AppColors.introSubtitleGrey,
  );

  // تنسيق خيار تذكرني.
  static TextStyle get rememberMeText => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    height: 1,
    color: AppColors.introSubtitleGrey,
  );

  // تنسيق عنوان نموذج الدخول.
  static TextStyle get loginTitle => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
    height: 1.2,
    color: AppColors.introNavy,
  );

  // تنسيق وصف نموذج الدخول.
  static TextStyle get loginSubtitle => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: AppColors.introSubtitleGrey,
  );

  // تنسيق عنوان حقل الدخول.
  static TextStyle get loginFieldLabel => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 12.sp,
    fontWeight: FontWeight.w700,
    height: 1,
    color: AppColors.introNavy,
  );

  // تنسيق النص الإرشادي لحقل الدخول.
  static TextStyle get loginFieldHintStyle => TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    height: 1,
    color: AppColors.loginFieldHint,
  );
}
