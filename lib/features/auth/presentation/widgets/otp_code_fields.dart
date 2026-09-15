import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

// يرتب خانات الرمز ويربط كل خانة بمتحكمها ومؤشر التركيز.
class OtpCodeFields extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final List<String> hints;
  final int activeCount;
  final void Function(String value, int index) onChanged;
  final FormFieldValidator<String>? validator;

  const OtpCodeFields({
    super.key,
    required this.controllers,
    required this.focusNodes,
    this.hints = const [],
    required this.activeCount,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 202.h,
          right: 26.w,
          child: Text(
            'أدخل كود التحقق (OTP)',
            textAlign: TextAlign.right,
            style: AppTextStyles.formLabelSmall,
          ),
        ),
        Positioned(
          top: 227.h,
          left: 20.w,
          child: Row(
            textDirection: TextDirection.ltr,
            children: List.generate(
              controllers.length,
              (index) => Padding(
                padding: EdgeInsets.only(
                  right: index == controllers.length - 1 ? 0 : 8.w,
                ),
                child: _OtpField(
                  controller: controllers[index],
                  focusNode: focusNodes[index],
                  hintText: index < hints.length ? hints[index] : '',
                  isActive: index < activeCount,
                  validator: validator,
                  onChanged: (value) => onChanged(value, index),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// خانة لرقم واحد من الرمز مع تنسيق موحد والتحقق من الإدخال.
class _OtpField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final bool isActive;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String> onChanged;

  const _OtpField({
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.isActive,
    this.validator,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38.w,
      height: 50.h,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        maxLength: 1,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: AppTextStyles.codeDigit,
        validator: validator,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.codeDigit.copyWith(
            color: AppColors.mutedText.withOpacity(0.35),
          ),
          counterText: '',
          filled: true,
          fillColor: AppColors.fieldBackground,
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(
              color: isActive ? AppColors.orange : AppColors.fieldBorder,
              width: isActive ? 2 : 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: AppColors.orange, width: 2),
          ),
          errorStyle: const TextStyle(fontSize: 0, height: 0),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: AppColors.orange, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: AppColors.orange, width: 2),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
