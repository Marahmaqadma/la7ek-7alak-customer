import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

// زر قابل لإعادة الاستخدام مع نص وألوان وأبعاد يحددها المستدعي.
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color backgroundColor;
  final TextStyle textStyle;
  final double? width;
  final double height;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.backgroundColor,
    required this.textStyle,
    this.width,
    this.height = 42,
    this.borderRadius = 10,
  });

  factory CustomButton.dark({
    required String text,
    required VoidCallback onTap,
    double? width,
  }) {
    return CustomButton(
      text: text,
      onTap: onTap,
      backgroundColor: AppColors.darkBrown,
      textStyle: AppTextStyles.buttonTextSmall,
      width: width ?? 270.w,
      height: 42.h,
      borderRadius: 10.r,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }
}
