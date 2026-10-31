import 'package:flutter/material.dart';
import '../widgets/welcome_wedgets/welcome_bottom_card.dart';
import '../widgets/welcome_wedgets/welcome_illustration_widget.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6E4EE),
      body: Stack(
        children: [
          // 1. الصورة تأخذ مساحة الشاشة بالكامل من الأعلى
          const Positioned.fill(
            bottom: 200, // عشان تخلص قبل آخر الشاشة بشوي وما تنزل تحت
            child: WelcomeIllustrationWidget(),
          ),

          // 2. الكارد الأبيض السفلي مثبت في الأسفل تماماً
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: WelcomeBottomCard(
              onLoginPressed: () {
                // الانتقال لتسجيل الدخول
              },
            ),
          ),
        ],
      ),
    );
  }
}
