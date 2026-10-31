import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

// "تواصل مباشر مع الدعم": واتساب يمينًا واتصال هاتفي يسارًا.
class SupportContactSection extends StatelessWidget {
  final VoidCallback onWhatsAppTap;
  final VoidCallback onPhoneTap;

  const SupportContactSection({
    super.key,
    required this.onWhatsAppTap,
    required this.onPhoneTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'تواصل مباشر مع الدعم',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.navy17244E,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: _ContactCard(
                title: 'محادثة واتساب',
                textColor: const Color(0xFFFF7A00),
                onTap: onWhatsAppTap,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _ContactCard(
                title: 'اتصال هاتفي',
                textColor: AppColors.navy17244E,
                onTap: onPhoneTap,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ContactCard extends StatelessWidget {
  final String title;
  final Color textColor;
  final VoidCallback onTap;

  const _ContactCard({
    required this.title,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF8FAFC),
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: SizedBox(
          height: 52.h,
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
