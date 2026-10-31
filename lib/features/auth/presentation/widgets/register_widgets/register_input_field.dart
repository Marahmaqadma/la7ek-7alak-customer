import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

// حقل تسجيل مع عنوان ورسالة تحقق وأيقونة صحة أو إظهار كلمة المرور.
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
      // الحقل الخارجي يحتفظ بنتيجة التحقق لعرض رسالة الخطأ أسفل الإدخال.
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
                  color: AppColors.introNavy,
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
                  // مزامنة القيمة المكتوبة مع حقل التحقق الخارجي.
                  state.didChange(val);
                },
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(
                      color: const Color(0xFF9EA3B0), fontSize: 13.sp),
                  filled: true,
                  fillColor: const Color(0xFFFCFDFF),
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
                    borderSide: const BorderSide(color: AppColors.introNavy),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: const BorderSide(color: Color(0xFFEF6F0F)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: const BorderSide(color: Color(0xFFEF6F0F)),
                  ),

                  errorText: null,
                  // إظهار زر كشف كلمة المرور عند توفره، أو علامة صحة الإدخال للحقول الأخرى.
                  suffixIcon: onEyeTap != null
                      ? IconButton(
                          icon: Icon(
                            isPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20.sp,
                            color: AppColors.grey,
                          ),
                          onPressed: onEyeTap,
                        )
                      : showCheck
                          ? Icon(
                              isChecked
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color: isChecked
                                  ? Colors.green
                                  : const Color(0xFF9EA3B0),
                              size: 20.sp,
                            )
                          : null,
                ),
              ),
              if (hasError) ...[
                SizedBox(height: 4.h),
                Text(
                  state.errorText!,
                  style: TextStyle(
                    color: const Color(0xFFEF6F0F),
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
