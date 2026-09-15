import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';
import 'package:la7ek_7alak/core/utils/validators.dart';

// يفتح قائمة المدن ويحفظ الاختيار داخل حالة حقل النموذج للتحقق منه.
class RegisterDropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final String? selectedCity;
  final ValueChanged<String> onCitySelected;

  const RegisterDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.selectedCity,
    required this.onCitySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.introNavy,
          ),
        ),
        SizedBox(height: 6.h),
        FormField<String>(
          initialValue: selectedCity,
          validator: Validators.city,
          builder: (field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    // فتح قائمة المدن دون مغادرة النموذج.
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Directionality(
                        textDirection: TextDirection.rtl,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            'شمال غزة',
                            'مدينة غزة',
                            'النصيرات',
                            'دير البلح',
                            'المغازي',
                            'البريج',
                            'خانيونس',
                          ]
                              .map(
                                (city) => ListTile(
                                  title: Text(city),
                                  onTap: () {
                                    onCitySelected(city);
                                    // إبلاغ النموذج بالقيمة المختارة حتى ينجح التحقق من حقل المدينة.
                                    field.didChange(city);
                                    Navigator.pop(context);
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 52.h,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCFDFF),
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(
                        color: field.hasError
                            ? const Color(0xFFEF6F0F)
                            : AppColors.fieldBorder,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedCity ?? hint,
                          style: TextStyle(
                            color: selectedCity != null
                                ? AppColors.introNavy
                                : const Color(0xFF9EA3B0),
                            fontSize: 13.sp,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.introNavy,
                          size: 24.sp,
                        ),
                      ],
                    ),
                  ),
                ),
                if (field.hasError)
                  Padding(
                    padding: EdgeInsets.only(top: 4.h, right: 4.w),
                    child: Text(
                      field.errorText!,
                      style: TextStyle(
                        color: const Color(0xFFEF6F0F),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
