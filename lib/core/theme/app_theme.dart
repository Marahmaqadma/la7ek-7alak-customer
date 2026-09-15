import 'package:flutter/material.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

// إعدادات الثيم الفاتح والخط الافتراضي للتطبيق.
class AppTheme {
  // ينشئ الثيم الفاتح بألوان التطبيق وخط تجوال.
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.orange),
      scaffoldBackgroundColor: AppColors.fieldBackground,
      useMaterial3: true,
      fontFamily: 'Tajawal',
    );
  }
}
