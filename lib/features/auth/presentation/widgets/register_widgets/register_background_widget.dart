import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// دوائر خلفية زخرفية لشاشة التسجيل.
class RegisterBackgroundWidget extends StatelessWidget {
  const RegisterBackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -20.h,
          left: -20.w,
          child: Container(
            width: 70.w,
            height: 70.h,
            decoration: const BoxDecoration(
              color: Color(0xFFF5EBE1),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          top: 170.h,
          right: -30.w,
          child: Container(
            width: 70.w,
            height: 70.h,
            decoration: const BoxDecoration(
              color: Color(0xFFF5EBE1),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
