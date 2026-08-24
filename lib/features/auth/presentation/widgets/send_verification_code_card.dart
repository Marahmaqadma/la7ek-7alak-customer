import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import 'otp_code_fields.dart';
import 'send_code_email_form.dart';

class SendVerificationCodeCard extends StatefulWidget {
  const SendVerificationCodeCard({super.key});

  @override
  State<SendVerificationCodeCard> createState() =>
      _SendVerificationCodeCardState();
}

class _SendVerificationCodeCardState extends State<SendVerificationCodeCard> {
  final emailController = TextEditingController(text: 'alaa@example.com');
  final otpControllers = List.generate(4, (_) => TextEditingController());
  final otpFocusNodes = List.generate(4, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    otpControllers[0].text = '5';
    otpControllers[1].text = '8';
  }

  @override
  void dispose() {
    emailController.dispose();

    for (final controller in otpControllers) {
      controller.dispose();
    }

    for (final focusNode in otpFocusNodes) {
      focusNode.dispose();
    }

    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < otpFocusNodes.length - 1) {
      otpFocusNodes[index + 1].requestFocus();
    }

    if (value.isEmpty && index > 0) {
      otpFocusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 310.w,
      height: 520.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Stack(
        children: [
          SendCodeEmailForm(
            controller: emailController,
            onSendCode: () {},
          ),
          OtpCodeFields(
            controllers: otpControllers,
            focusNodes: otpFocusNodes,
            activeCount: 2,
            onChanged: _onOtpChanged,
          ),
          const ResendTimerText(),
          Positioned(
            top: 324.h,
            left: 20.w,
            child: CustomButton.dark(
              text: 'تحقق',
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class ResendTimerText extends StatelessWidget {
  final String time;

  const ResendTimerText({
    super.key,
    this.time = '00:45',
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 286.h,
      left: 0,
      right: 0,
      child: Text.rich(
        textAlign: TextAlign.center,
        TextSpan(
          text: 'إعادة إرسال الكود خلال ',
          style: AppTextStyles.captionMuted,
          children: [
            TextSpan(
              text: time,
              style: AppTextStyles.captionHighlight,
            ),
          ],
        ),
      ),
    );
  }
}
