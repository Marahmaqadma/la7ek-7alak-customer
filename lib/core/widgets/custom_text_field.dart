import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class CustomTextField extends StatelessWidget {
  // Placeholder shown before the user types.
  final String hintText;

  // Gives the parent access to the entered value.
  final TextEditingController? controller;

  // True for password fields.
  final bool obscureText;

  // Controls which keyboard appears.
  final TextInputType? keyboardType;

  // Optional icon inside the field.
  final Widget? suffixIcon;

  // Used when the Figma hint needs an underline.
  final bool underlineHint;

  // Allows each screen to provide its own validation.
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.underlineHint = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Exact TextField size from Figma.
      width: 270.w,
      height: 44.h,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,

        // Arabic input starts from the right.
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        textAlignVertical: TextAlignVertical.center,

        // Style of text entered by the user.
        style: AppTextStyles.fieldHint.copyWith(
          color: AppColors.darkBrown,
        ),

        decoration: InputDecoration(
          hintText: hintText,

          // Style of the placeholder.
          hintStyle: AppTextStyles.fieldHint.copyWith(
            decoration:
            underlineHint ? TextDecoration.underline : TextDecoration.none,
          ),

          // Enables the Figma background color.
          filled: true,
          fillColor: AppColors.fieldBackground,

          // Helps the content fit inside the 44px field height.
          isDense: false,

          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
          ),

          // In RTL, the suffix appears on the left.
          suffixIcon: suffixIcon,

          suffixIconConstraints: BoxConstraints(
            minWidth: 44.w,
            minHeight: 44.h,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(
              color: AppColors.fieldBorder,
              width: 1,
            ),
          ),

          // Border when the user taps the field.
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(
              color: AppColors.orange,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}