import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';

// شاشة الترحيب؛ تعرض الرسم والوصف وتفتح اختيار نوع المستخدم.
class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: LayoutBuilder(
            builder: (context, constraints) {
              // تكبير عناصر التصميم بما يناسب العرض، مع حد أعلى للشاشات الكبيرة.
              final scale = math.min(constraints.maxWidth / 375, 1.4);
              final width = 375 * scale;
              final height = math.max(constraints.maxHeight, 812 * scale);
              final bottomInset = MediaQuery.paddingOf(context).bottom;
              final textScale = MediaQuery.textScalerOf(context).scale(1);

              // إضافة مساحة عند تكبير خط النظام حتى لا يتداخل النص مع الزر.
              final extraTextHeight = math.max(0.0, textScale - 1) * 90 * scale;

              return SingleChildScrollView(
                child: SizedBox(
                  height: height + extraTextHeight,
                  child: Stack(
                    children: [
                      Positioned(
                        top: height - 758 * scale,
                        left: (constraints.maxWidth - width) / 2,
                        width: width,
                        child: Image.asset(
                          'assets/images/intro_illustration.jpg',
                          fit: BoxFit.fitWidth,
                          excludeFromSemantics: true,
                        ),
                      ),
                      Positioned(
                        top: height - 276 * scale,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        // قص المساحة البيضاء لتأخذ شكل المنحنى فوق أسفل الرسم.
                        child: ClipPath(
                          clipper: _WelcomeCurve(scale),
                          child: const ColoredBox(color: AppColors.white),
                        ),
                      ),
                      Positioned(
                        top: height - 216 * scale,
                        left: (constraints.maxWidth - width) / 2 + 15 * scale,
                        width: 343 * scale,
                        child: Column(
                          children: [
                            Text(
                              'أهلاً بك في لحق حالك',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.introTitle.copyWith(
                                fontSize: 20 * scale,
                                height: 1,
                                letterSpacing: -0.5 * scale,
                                color: AppColors.introNavy,
                              ),
                            ),
                            SizedBox(height: 10 * scale),
                            SizedBox(
                              width: 259 * scale,
                              child: Text(
                                'عروضك القريبة بوقتها المناسب اكتشف\nالعروض قبل ما تخلص',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.introSubtitle.copyWith(
                                  fontSize: 14 * scale,
                                  height: 25 / 14,
                                  color: const Color(0xFF6B6B70),
                                ),
                              ),
                            ),
                            SizedBox(height: 40 * scale),
                            CustomButton(
                              text: 'تسجيل الدخول',
                              onTap: () => Navigator.of(context)
                                  .pushReplacementNamed(AppRouter.login),
                              backgroundColor: AppColors.introNavy,
                              textStyle: AppTextStyles.introButtonText.copyWith(
                                fontSize: 14 * scale,
                                height: 17 / 14,
                              ),
                              width: 343 * scale,
                              height:
                                  math.max(48 * scale, 48 * scale * textScale),
                              borderRadius: 15 * scale,
                            ),
                            SizedBox(height: math.max(48 * scale, bottomInset)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// يرسم الحافة المنحنية للمساحة البيضاء أسفل صورة الترحيب.
class _WelcomeCurve extends CustomClipper<Path> {
  const _WelcomeCurve(this.scale);

  final double scale;

  // يحدد مسار الحافة المنحنية بحسب عرض الشاشة ومقياس التصميم.
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 64 * scale)
      ..cubicTo(size.width * .07, -14 * scale, size.width * .19, 2 * scale,
          size.width * .39, 7 * scale)
      ..cubicTo(size.width * .58, 13 * scale, size.width * .88, -15 * scale,
          size.width, 56 * scale)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  // يعيد رسم المنحنى فقط عندما يتغير مقياسه.
  @override
  bool shouldReclip(_WelcomeCurve oldClipper) => oldClipper.scale != scale;
}
