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
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;

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
    this.validator,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: height?.h ?? 0),
      child: SizedBox(
        width: width?.w,
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textDirection: textDirection,
          validator: validator,
          autovalidateMode: autovalidateMode,
          style:
              textStyle ??
              TextStyle(fontSize: 14.sp, color: AppColors.darkBrown),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle:
                hintStyle ??
                AppTextStyles.fieldHint.copyWith(
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
            errorMaxLines: 2,
            errorStyle: TextStyle(fontSize: 10.sp, color: AppColors.orange),
          ),
        ),
      ),
    );
  }
}
