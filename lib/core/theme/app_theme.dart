import 'package:flutter/material.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.orange),
      scaffoldBackgroundColor: AppColors.fieldBackground,
      useMaterial3: true,
    );
  }
}
