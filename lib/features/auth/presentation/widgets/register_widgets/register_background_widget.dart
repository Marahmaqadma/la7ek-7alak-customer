import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterBackgroundWidget extends StatelessWidget {
  const RegisterBackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // الدائرة العلوية اليسرى (بحجم مطابق لـ Figma تقريباً 70x70)
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
        // الدائرة اليمنى بالأسفل قليلاً
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
