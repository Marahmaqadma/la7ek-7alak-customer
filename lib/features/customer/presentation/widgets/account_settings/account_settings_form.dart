import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

// حقول البيانات الشخصية ومفاتيح تفضيلات الإشعارات.
class AccountSettingsFormSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final bool newOffersNotification;
  final bool expiringOffersNotification;
  final ValueChanged<bool> onNewOffersChanged;
  final ValueChanged<bool> onExpiringOffersChanged;

  const AccountSettingsFormSection({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.newOffersNotification,
    required this.expiringOffersNotification,
    required this.onNewOffersChanged,
    required this.onExpiringOffersChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle('البيانات الشخصية'),
        SizedBox(height: 8.h),
        CustomerTextField(controller: nameController, hintText: 'الاسم الكامل'),
        SizedBox(height: 8.h),
        CustomerTextField(
          controller: phoneController,
          hintText: 'رقم الجوال',
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 20.h),
        _sectionTitle('تفضيلات الإشعارات'),
        SizedBox(height: 8.h),
        _SwitchTile(
          title: 'إشعارات العروض الجديدة',
          value: newOffersNotification,
          onChanged: onNewOffersChanged,
        ),
        SizedBox(height: 8.h),
        _SwitchTile(
          title: 'التنبيه بقرب انتهاء العروض المتابعة',
          value: expiringOffersNotification,
          onChanged: onExpiringOffersChanged,
        ),
      ],
    );
  }

  Widget _sectionTitle(String text) => Text(
        text,
        style: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 14.sp,
          fontWeight: FontWeight.w800,
          color: AppColors.navy17244E,
        ),
      );
}

// حقل نص بخلفية رمادية فاتحة بدون إطار، مشترك بين الإعدادات والدعم.
class CustomerTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final double? height;
  final bool multiline;

  const CustomerTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.height,
    this.multiline = false,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide.none,
    );

    return SizedBox(
      height: height ?? 48.h,
      child: TextField(
        controller: controller,
        keyboardType: multiline ? TextInputType.multiline : keyboardType,
        maxLines: multiline ? null : 1,
        expands: multiline,
        textAlignVertical:
            multiline ? TextAlignVertical.top : TextAlignVertical.center,
        style: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 13.sp,
          color: AppColors.navy17244E,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 12.sp,
            color: const Color(0xFF94A3B8),
          ),
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          border: border,
          enabledBorder: border,
          focusedBorder: border,
        ),
      ),
    );
  }
}

// العنوان يمينًا والمفتاح البرتقالي يسارًا.
class _SwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.navy17244E,
              ),
            ),
          ),
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFFFF7A00),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xFFCBD5E1),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
