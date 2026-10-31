import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeIllustrationWidget extends StatelessWidget {
  const WelcomeIllustrationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      // درجة اللون السماوي الهادئ المطابقة تماماً لتصميم الفيجما
      color: const Color(0xFFE3EDF7),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            // نزلنا الشب لتحت شوي عشان يكون جزء منه ظاهر ورا الكارد الأبيض زي الفيجما
            top: 170.h,
            child: Image.asset(
              'assets/images/welcome_photo.png',
              width: 330.w,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
