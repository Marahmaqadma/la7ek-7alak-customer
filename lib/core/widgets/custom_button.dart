import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final double width;
  final double height;
  final double borderRadius;
  final Color backgroundColor;
  final TextStyle? textStyle;

  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.width = 270,
    this.height = 46,
    this.borderRadius = 8,
    this.backgroundColor = AppColors.darkBrown,
    this.textStyle,
  });

  const CustomButton.dark({
    super.key,
    required this.text,
    this.onTap,
    this.width = 270,
    this.height = 46,
    this.borderRadius = 8,
    this.backgroundColor = AppColors.darkBrown,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width.w,
        height: height.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
        child: Text(
          text,
          style: textStyle ?? AppTextStyles.buttonTextSmall,
        ),
      ),
    );
  }
}
