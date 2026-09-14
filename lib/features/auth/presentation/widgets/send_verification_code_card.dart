import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
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
  final _emailFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final otpControllers = List.generate(6, (_) => TextEditingController());
  final otpFocusNodes = List.generate(6, (_) => FocusNode());

  Timer? _timer;
  int _secondsLeft = 0;
  bool _isLoading = false;

  @override
  void dispose() {
    _timer?.cancel();
    emailController.dispose();

    for (final controller in otpControllers) {
      controller.dispose();
    }

    for (final focusNode in otpFocusNodes) {
      focusNode.dispose();
    }

    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = 45);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < otpFocusNodes.length - 1) {
      otpFocusNodes[index + 1].requestFocus();
    }

    if (value.isEmpty && index > 0) {
      otpFocusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _sendFirebaseResetEmail() async {
    if (!_emailFormKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      _startTimer();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني بنجاح'),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'حدث خطأ أثناء إرسال البريد الإلكتروني'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
          Positioned.fill(
            child: Form(
              key: _emailFormKey,
              child: SendCodeEmailForm(
                controller: emailController,
                validator: Validators.email,
                isLoading: _isLoading,
                onSendCode: _sendFirebaseResetEmail,
              ),
            ),
          ),
          Positioned.fill(
            child: Form(
              key: _otpFormKey,
              child: OtpCodeFields(
                controllers: otpControllers,
                focusNodes: otpFocusNodes,
                activeCount: otpControllers.length,
                hints: const ['5', '8', '', '', '', ''],
                validator: Validators.otpDigit,
                onChanged: _onOtpChanged,
              ),
            ),
          ),
          ResendTimerText(secondsLeft: _secondsLeft),
          Positioned(
            top: 324.h,
            left: 20.w,
            child: CustomButton.dark(
              text: 'تحقق',
              onTap: () {
                if (_otpFormKey.currentState!.validate()) {
                  // يمكن استدعاء إجراء التحقق هنا إن وجد
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ResendTimerText extends StatelessWidget {
  final int secondsLeft;

  const ResendTimerText({super.key, required this.secondsLeft});

  String get time {
    final minutes = (secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsLeft % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final isRunning = secondsLeft > 0;

    return Positioned(
      top: 286.h,
      left: 0,
      right: 0,
      child: Text.rich(
        textAlign: TextAlign.center,
        TextSpan(
          text: isRunning
              ? 'إعادة إرسال الكود خلال '
              : 'يمكنك إعادة إرسال الكود الآن',
          style: AppTextStyles.captionMuted,
          children: [
            if (isRunning)
              TextSpan(text: time, style: AppTextStyles.captionHighlight),
          ],
        ),
      ),
    );
  }
}
