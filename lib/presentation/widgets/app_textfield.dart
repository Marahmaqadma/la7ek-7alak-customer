import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constance/app_colors.dart';
import '../../constance/app_text_styles.dart';

class AppTextField extends StatelessWidget {

  final String hintText;
  //obscure: unvisible text(dotted)
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController? textFieldController;
  final TextInputType? keyboardType;

  const AppTextField({
    super.key,
    required this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.textFieldController,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270.w,
      height: 44.h,
      child: TextFormField(
        controller: textFieldController,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textAlign: TextAlign.right,
        //text inside the field
        style: AppTextStyles.fieldHint.copyWith(
          color: AppColors.darkBrown,
        ),

        decoration: InputDecoration(
          hintText: hintText,
          //before typing
          hintStyle: AppTextStyles.fieldHint,

          filled: true,
          //background
          fillColor: AppColors.fieldBackground,

          suffixIcon: suffixIcon,

          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 12.h,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(
              color: AppColors.lightOrange,
              width: 1,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(
              color: AppColors.orange,
              width: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}