import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../data/models/forgot_password/forgot_password_request_body.dart';
import '../../data/models/verify_otp/verify_otp_request_body.dart';
import '../cubit/forgot_password/forgot_password_cubit.dart';
import '../cubit/verify_otp/verify_otp_cubit.dart';
import 'otp_code_fields.dart';
import 'send_code_email_form.dart';

// واجهة رمز التحقق للخدمة السابقة؛ ليست شاشة الاستعادة المستخدمة مع Firebase.
class SendVerificationCodeCard extends StatefulWidget {
  const SendVerificationCodeCard({super.key});

  @override
  State<SendVerificationCodeCard> createState() =>
      _SendVerificationCodeCardState();
}

// يدير خانات الرمز والتنقل بينها ومؤقت إعادة الإرسال.
class _SendVerificationCodeCardState extends State<SendVerificationCodeCard> {
  final _emailFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final otpControllers = List.generate(6, (_) => TextEditingController());

  final otpFocusNodes = List.generate(6, (_) => FocusNode());

  Timer? _timer;
  int _secondsLeft = 0;

  // يحرر متحكمات الحقول والموارد المستخدمة عند إغلاق الواجهة.
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

  // يعيد بدء عداد 45 ثانية ويحدّث الوقت المعروض كل ثانية.
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

  // ينقل التركيز للخانة التالية عند الكتابة وللسابقة عند الحذف.
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
    final forgotPasswordState = context.watch<ForgotPasswordCubit>().state;
    final verifyOtpState = context.watch<VerifyOtpCubit>().state;
    final isSendingCode = forgotPasswordState is ForgotPasswordLoading;
    final isVerifyingOtp = verifyOtpState is VerifyOtpLoading;

    return MultiBlocListener(
      listeners: [
        BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
          // يتابع نتيجة الطلب لإظهار رسالة للمستخدم أو الانتقال إلى الشاشة التالية.
          listener: (context, state) {
            if (state is ForgotPasswordSuccess) {
              _startTimer();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.forgotPasswordResponse.message ??
                        'تم إرسال رمز التحقق إلى البريد الإلكتروني',
                  ),
                ),
              );
            } else if (state is ForgotPasswordError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
        ),
        BlocListener<VerifyOtpCubit, VerifyOtpState>(
          // يتابع نتيجة الطلب لإظهار رسالة للمستخدم أو الانتقال إلى الشاشة التالية.
          listener: (context, state) {
            if (state is VerifyOtpSuccess) {
              Navigator.pushNamed(
                context,
                AppRouter.resetPassword,
                arguments: emailController.text.trim(),
              );
            } else if (state is VerifyOtpError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
        ),
      ],
      child: Container(
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
                  isLoading: isSendingCode,
                  onSendCode: () {
                    if (_emailFormKey.currentState!.validate()) {
                      context.read<ForgotPasswordCubit>().forgotPassword(
                            ForgotPasswordRequestBody(
                              email: emailController.text.trim(),
                            ),
                          );
                    }
                  },
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
              child: isVerifyingOtp
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton.dark(
                      text: 'تحقق',
                      // لا يرسل الطلب إلا بعد اجتياز الحقول لقواعد التحقق.
                      onTap: () {
                        if (_otpFormKey.currentState!.validate()) {
                          context.read<VerifyOtpCubit>().verifyOtp(
                                VerifyOtpRequestBody(
                                  email: emailController.text.trim(),
                                  otp: otpControllers
                                      .map((controller) =>
                                          controller.text.trim())
                                      .join(),
                                ),
                              );
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// يعرض الوقت المتبقي قبل السماح بإعادة إرسال الرمز.
class ResendTimerText extends StatelessWidget {
  final int secondsLeft;

  const ResendTimerText({super.key, required this.secondsLeft});

  // ينسّق مدة الانتظار لتظهر بالدقائق والثواني.
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
