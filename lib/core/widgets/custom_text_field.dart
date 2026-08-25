import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final bool underlineHint;
  final double? width;
  final double? height;
  final double? borderRadius;
  final TextDirection? textDirection;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.underlineHint = false,
    this.width,
    this.height,
    this.borderRadius,
    this.textDirection,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.textStyle,
    this.hintStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width?.w,
      height: height?.h,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textDirection: textDirection,
        style: textStyle ?? TextStyle(
          fontSize: 14.sp,
          color: AppColors.darkBrown,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: hintStyle ?? AppTextStyles.fieldHint.copyWith(
            decoration: underlineHint ? TextDecoration.underline : null,
          ),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: AppColors.fieldBackground,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15.w,
            vertical: 12.h,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius?.r ?? 10.r),
            borderSide: BorderSide(
              color: enabledBorderColor ?? AppColors.fieldBorder,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius?.r ?? 10.r),
            borderSide: BorderSide(
              color: focusedBorderColor ?? AppColors.orange,
              width: 1.5,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius?.r ?? 10.r),
          ),
        ),
      ),
    );
  }
}
