import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class OtpCodeFields extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final int activeCount;
  final void Function(String value, int index) onChanged;

  const OtpCodeFields({
    super.key,
    required this.controllers,
    required this.focusNodes,
    required this.activeCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
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
                    right: index == controllers.length - 1 ? 0 : 15.w,
                  ),
                  child: _OtpField(
                    controller: controllers[index],
                    focusNode: focusNodes[index],
                    isActive: index < activeCount,
                    onChanged: (value) => onChanged(value, index),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OtpField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isActive;
  final ValueChanged<String> onChanged;

  const _OtpField({
    required this.controller,
    required this.focusNode,
    required this.isActive,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 55.w,
      height: 50.h,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        maxLength: 1,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: AppTextStyles.codeDigit,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
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
            borderSide: const BorderSide(
              color: AppColors.orange,
              width: 2,
            ),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
