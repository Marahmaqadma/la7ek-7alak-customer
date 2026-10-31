import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

import '../account_settings/account_settings_form.dart';

// "أرسل استفسارك أو مشكلتك": حقل العنوان وحقل التفاصيل.
class SupportFormSection extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController messageController;

  const SupportFormSection({
    super.key,
    required this.titleController,
    required this.messageController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'أرسل استفسارك أو مشكلتك',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.navy17244E,
          ),
        ),
        SizedBox(height: 8.h),
        CustomerTextField(
          controller: titleController,
          hintText: 'عنوان الاستفسار',
        ),
        SizedBox(height: 10.h),
        CustomerTextField(
          controller: messageController,
          hintText: 'اكتب تفاصيل الرسالة هنا...',
          height: 120.h,
          multiline: true,
        ),
      ],
    );
  }
}
