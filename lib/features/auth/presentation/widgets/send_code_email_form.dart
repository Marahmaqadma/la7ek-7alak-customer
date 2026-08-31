import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

class SendCodeEmailForm extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSendCode;
  final FormFieldValidator<String>? validator;
  final bool isLoading;

  const SendCodeEmailForm({
    super.key,
    required this.controller,
    required this.onSendCode,
    this.validator,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 39.h,
          left: 0,
          right: 26.w,
          child: Text(
            'أدخل بريدك الإلكتروني لإرسال رمز التحقق',
            textAlign: TextAlign.start,
            style: AppTextStyles.formLabelSmall,
          ),
        ),
        Positioned(
          top: 65.h,
          left: 20.w,
          child: CustomTextField(
            controller: controller,
            hintText: 'alaa@example.com',
            keyboardType: TextInputType.emailAddress,
            underlineHint: true,
            width: 270,
            height: 42,
            borderRadius: 8,
            textDirection: TextDirection.ltr,
            enabledBorderColor: AppColors.accentLight,
            focusedBorderColor: AppColors.orange,
            textStyle: AppTextStyles.underlinedFieldText,
            hintStyle: AppTextStyles.underlinedFieldText,
            validator: validator,
          ),
        ),
        Positioned(
          top: 116.h,
          left: 20.w,
          child: CustomButton.dark(
            text: isLoading ? 'جاري الإرسال...' : 'إرسال رمز التحقق',
            onTap: isLoading ? () {} : onSendCode,
          ),
        ),
      ],
    );
  }
}
