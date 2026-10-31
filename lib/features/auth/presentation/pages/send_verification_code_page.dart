import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../data/models/forgot_password/forgot_password_request_body.dart';
import '../cubit/forgot_password/forgot_password_cubit.dart';

// ترسل رابط إعادة تعيين كلمة المرور وتعرض تأكيد الإرسال.
class SendVerificationCodePage extends StatefulWidget {
  const SendVerificationCodePage({super.key});

  @override
  State<SendVerificationCodePage> createState() =>
      _SendVerificationCodePageState();
}

// يدير البريد المدخل ونتيجة الإرسال والوقت المتبقي لإعادة الإرسال.
class _SendVerificationCodePageState extends State<SendVerificationCodePage> {
  final _emailFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  // بعد نجاح الإرسال تعرض الصفحة تعليمات فتح البريد بدل نموذج الإدخال.
  bool _linkSent = false;

  // عداد محلي يحدد وقت إتاحة إعادة إرسال الرابط.
  Timer? _timer;
  int _secondsLeft = 0;

  // يحرر متحكمات الحقول والموارد المستخدمة عند إغلاق الواجهة.
  @override
  void dispose() {
    _timer?.cancel();
    emailController.dispose();
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

  // يحوّل الثواني المتبقية إلى نص بالدقائق والثواني.
  String get _timeText {
    final minutes = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // يرسل البريد المدخل إلى مدير حالة استعادة كلمة المرور.
  void _sendResetEmail() {
    context.read<ForgotPasswordCubit>().forgotPassword(
          ForgotPasswordRequestBody(email: emailController.text.trim()),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            Positioned(
              top: -30.h,
              right: -40.w,
              child: _decorativeCircle(140.w),
            ),
            Positioned(
              bottom: 40.h,
              left: -50.w,
              child: _decorativeCircle(110.w),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
                  // يتابع نتيجة الطلب لإظهار رسالة للمستخدم أو الانتقال إلى الشاشة التالية.
                  listener: (context, state) {
                    if (state is ForgotPasswordSuccess) {
                      // الانتقال إلى تعليمات البريد وبدء مهلة إعادة الإرسال.
                      setState(() => _linkSent = true);
                      _startTimer();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.forgotPasswordResponse.message ??
                                'تم إرسال رابط إعادة تعيين كلمة المرور إلى '
                                    'بريدك الإلكتروني',
                          ),
                        ),
                      );
                    } else if (state is ForgotPasswordError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error)),
                      );
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 12.h),
                      const Center(child: _EnvelopeIllustration()),
                      SizedBox(height: 20.h),
                      Text(
                        'هل نسيت كلمة المرور؟',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.userTypeTitle,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        _linkSent
                            ? 'تحقق من بريدك الإلكتروني'
                            : 'قم بادخال بريدك الإلكتروني الذي قمت بالتسجيل '
                                'فيه لإرسال رابط إعادة تعيين كلمة المرور',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.userTypeSubtitle,
                      ),
                      SizedBox(height: 28.h),
                      if (!_linkSent)
                        _EmailStep(
                          formKey: _emailFormKey,
                          controller: emailController,
                          onSend: () {
                            if (_emailFormKey.currentState!.validate()) {
                              _sendResetEmail();
                            }
                          },
                        )
                      else
                        _CheckEmailStep(
                          email: emailController.text.trim(),
                          secondsLeft: _secondsLeft,
                          timeText: _timeText,
                          // لا يُتاح إرسال رابط جديد قبل انتهاء العداد.
                          onResend: _secondsLeft == 0 ? _sendResetEmail : null,
                          onEditEmail: () => setState(() => _linkSent = false),
                        ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ينشئ دائرة خلفية بالحجم المطلوب.
  Widget _decorativeCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.decorativePeach,
      ),
    );
  }
}

// نموذج البريد وزر إرسال رابط الاستعادة مع حالة التحميل.
class _EmailStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final VoidCallback onSend;

  const _EmailStep({
    required this.formKey,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final isSending =
        context.watch<ForgotPasswordCubit>().state is ForgotPasswordLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('البريد الإلكتروني', style: AppTextStyles.loginFieldLabel),
              SizedBox(height: 8.h),
              CustomTextField(
                controller: controller,
                hintText: 'ayaayaaya@gmail',
                keyboardType: TextInputType.emailAddress,
                textDirection: TextDirection.ltr,
                validator: Validators.email,
                height: 48,
                borderRadius: 15,
                fillColor: AppColors.loginFieldFill,
                enabledBorderColor: Colors.transparent,
                focusedBorderColor: AppColors.introNavy,
                hintStyle: AppTextStyles.loginFieldHintStyle,
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        Center(
          child: isSending
              ? const CircularProgressIndicator()
              : CustomButton(
                  text: 'إرسال رابط إعادة التعيين',
                  onTap: onSend,
                  backgroundColor: AppColors.introNavy,
                  textStyle: AppTextStyles.introButtonText,
                  width: double.infinity,
                  height: 48.h,
                  borderRadius: 15.r,
                ),
        ),
      ],
    );
  }
}

// يعرض البريد المرسل إليه الرابط ويتيح إعادة الإرسال أو تعديل العنوان.
class _CheckEmailStep extends StatelessWidget {
  final String email;
  final int secondsLeft;
  final String timeText;
  final VoidCallback? onResend;
  final VoidCallback onEditEmail;

  const _CheckEmailStep({
    required this.email,
    required this.secondsLeft,
    required this.timeText,
    required this.onResend,
    required this.onEditEmail,
  });

  @override
  Widget build(BuildContext context) {
    final isResending =
        context.watch<ForgotPasswordCubit>().state is ForgotPasswordLoading;
    final isRunning = secondsLeft > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'أرسلنا رابط إعادة تعيين كلمة المرور إلى:',
          textAlign: TextAlign.center,
          style: AppTextStyles.loginFieldLabel,
        ),
        SizedBox(height: 4.h),
        Text(
          email,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          style: AppTextStyles.loginFieldLabel.copyWith(
            color: AppColors.introNavy,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          'افتح الرابط من بريدك الإلكتروني لتعيين كلمة مرور جديدة، ثم عُد '
          'إلى شاشة تسجيل الدخول.',
          textAlign: TextAlign.center,
          style: AppTextStyles.userTypeSubtitle,
        ),
        SizedBox(height: 20.h),
        Center(
          child: GestureDetector(
            onTap: onResend,
            child: Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                text: isRunning
                    ? 'يمكنك إعادة إرسال الرابط خلال '
                    : 'يمكنك إعادة إرسال الرابط الآن',
                style: AppTextStyles.captionMuted,
                children: [
                  if (isRunning)
                    TextSpan(
                      text: timeText,
                      style: AppTextStyles.captionHighlight,
                    ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Center(
          child: isResending
              ? const CircularProgressIndicator()
              : TextButton(
                  onPressed: onEditEmail,
                  child: Text(
                    'تعديل البريد الإلكتروني',
                    style: AppTextStyles.loginFieldLabel
                        .copyWith(color: AppColors.orange),
                  ),
                ),
        ),
      ],
    );
  }
}

// يعرض صورة البريد بجودتها الأصلية داخل المساحة المخصصة.
class _EnvelopeIllustration extends StatelessWidget {
  const _EnvelopeIllustration();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/email_illustration.jpg',
      width: 140.w,
      height: 140.w,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      excludeFromSemantics: true,
    );
  }
}
