import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

class StoreProfileForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController bioController;
  final String selectedLocation;
  final ValueChanged<String?> onLocationChanged;

  const StoreProfileForm({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.bioController,
    required this.selectedLocation,
    required this.onLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> locations = [
      'شمال غزة',
      'مدينة غزة',
      'النصيرات',
      'دير البلح',
      'المغازي',
      'البريج',
      'خانيونس',
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // اسم المتجر / التجاري
          _buildLabel('اسم المتجر / التجاري *'),
          SizedBox(height: 6.h),
          _buildTextField(controller: nameController, hint: 'أدخل اسم المتجر'),
          SizedBox(height: 14.h),

          // رقم الواتساب
          _buildLabel('رقم الواتساب للتواصل والطلبات *'),
          SizedBox(height: 6.h),
          _buildTextField(
            controller: phoneController,
            hint: '+970 599 000 000',
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 14.h),

          // الموقع الجغرافي / المنطقة
          _buildLabel('الموقع الجغرافي / المنطقة *'),
          SizedBox(height: 6.h),
          Container(
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: locations.contains(selectedLocation) ? selectedLocation : locations.first,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.orange),
                items: locations.map((String location) {
                  return DropdownMenuItem<String>(
                    value: location,
                    alignment: Alignment.centerRight,
                    child: Text(
                      location,
                      style: TextStyle(fontSize: 13.sp, color: AppColors.orange),
                    ),
                  );
                }).toList(),
                onChanged: onLocationChanged,
              ),
            ),
          ),
          SizedBox(height: 14.h),

          // نبذة عن المتجر
          _buildLabel('نبذة عن المتجر (اختياري)'),
          SizedBox(height: 6.h),
          TextField(
            controller: bioController,
            maxLines: 3,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 13.sp, color: AppColors.orange),
            decoration: InputDecoration(
              hintText: 'أفخم أنواع البيتزا والوجبات السريعة بأفضل الأسعار...',
              hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey.shade400),
              contentPadding: EdgeInsets.all(12.w),
              filled: true,
              fillColor: AppColors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: AppColors.orange, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // دالة الليبل مع النجمة على اليسار باللون البرتقالي
  Widget _buildLabel(String text) {
    final cleanText = text.replaceAll('*', '').trim();
    final bool hasStar = text.contains('*');

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Align(
        alignment: Alignment.centerRight,
        child: RichText(
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          text: TextSpan(
            // يرث الخط الافتراضي من الـ Theme (مثل Tajawal) تلقائياً
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBrown,
            ),
            children: [
              TextSpan(text: cleanText),
              if (hasStar)
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: AppColors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final bool isPhone = keyboardType == TextInputType.phone;

    return SizedBox(
      height: 46.h,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        // للرقم نجعله ltr عشان الرموز تقرأ صح، لكن المحاذاة يمين
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 13.sp,
          color: AppColors.orange,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintTextDirection: TextDirection.ltr,
          hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey.shade400),
          contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
          filled: true,
          fillColor: AppColors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: AppColors.orange, width: 1.5),
          ),
        ),
      ),
    );
  }
}