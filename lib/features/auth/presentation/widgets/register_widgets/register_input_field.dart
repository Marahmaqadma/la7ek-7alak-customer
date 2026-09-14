import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

class RegisterInputField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final String? helperText;
  final FormFieldValidator<String>? validator;
  final bool isPassword;
  final bool showCheck;
  final bool isChecked;
  final TextDirection? textDirection;
  final VoidCallback? onEyeTap;
  final TextAlign textAlign;
  final TextInputType? keyboardType;

  const RegisterInputField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.helperText,
    this.validator,
    this.isPassword = false,
    this.showCheck = false,
    this.isChecked = false,
    this.textDirection,
    this.onEyeTap,
    this.textAlign = TextAlign.right,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 299.w,
      child: FormField<String>(
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        builder: (FormFieldState<String> state) {
          bool hasError = state.hasError;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryNavy,
                ),
              ),
              SizedBox(height: 6.h),
              TextFormField(
                controller: controller,
                textAlign: textAlign,
                obscureText: isPassword,
                textDirection: textDirection,
                keyboardType: keyboardType,
                onChanged: (val) {
                  state.didChange(val);
                },
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(color: AppColors.mutedText, fontSize: 13.sp),
                  filled: true,
                  fillColor: AppColors.fieldBackground,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: const BorderSide(color: AppColors.fieldBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: const BorderSide(color: AppColors.primaryNavy),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: const BorderSide(color: AppColors.accentOrange),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: const BorderSide(color: AppColors.accentOrange),
                  ),
                  // إلغاء errorText الاقتصادي الداخلي لمنع تضارب المحاذاة
                  errorText: null,
                  suffixIcon: onEyeTap != null
                      ? IconButton(
                    icon: Icon(
                      isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      size: 20.sp,
                      color: AppColors.grey,
                    ),
                    onPressed: onEyeTap,
                  )
                      : showCheck
                      ? Icon(
                    isChecked ? Icons.check_circle : Icons.circle_outlined,
                    color: isChecked ? Colors.green : AppColors.mutedText,
                    size: 20.sp,
                  )
                      : null,
                ),
              ),
              // عرض نص الخطأ بخاصية مستقلة تضمن تطابقه تماماً مع حقل المدينة
              if (hasError) ...[
                SizedBox(height: 4.h),
                Text(
                  state.errorText!,
                  style: TextStyle(
                    color: AppColors.accentOrange,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

