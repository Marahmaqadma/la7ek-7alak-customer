import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/send_verification_code_card.dart';

class SendVerificationCodePage extends StatelessWidget {
  const SendVerificationCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.fieldBackground,
                AppColors.surfaceWarm,
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  width: 360.w,
                  height: 780.h,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 24.h,
                        left: 126.w,
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 108.w,
                          height: 108.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        top: 122.h,
                        left: 0,
                        right: 0,
                        child: Text(
                          'إرسال كود التحقق',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.pageTitleLarge,
                        ),
                      ),
                      Positioned(
                        top: 150.h,
                        left: 0,
                        right: 0,
                        child: Text(
                          'سيتم إرسال كود التحقق عبر الإيميل',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.pageSubtitleSmall,
                        ),
                      ),
                      Positioned(
                        top: 190.h,
                        left: 25.w,
                        child: const SendVerificationCodeCard(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
