import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';
import 'package:la7ek_7alak/core/utils/validators.dart';

// حقل المدينة في التسجيل: يعرض المدينة المختارة، والضغط عليه يطلب من الصفحة
// اختيار الموقع على الخريطة. [onPickCity] ترجع اسم المدينة الأقرب، أو null إن
// رجع الزبون بدون تأكيد. القيمة تُحفظ في حالة الحقل للتحقق منها.
class RegisterDropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final String? selectedCity;
  final Future<String?> Function() onPickCity;

  const RegisterDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.selectedCity,
    required this.onPickCity,
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
                  onTap: () async {
                    final city = await onPickCity();
                    // إبلاغ النموذج بالقيمة المختارة حتى ينجح التحقق من الحقل.
                    if (city != null && field.mounted) field.didChange(city);
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
                      children: [
                        Expanded(
                          child: Text(
                            selectedCity ?? hint,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: selectedCity != null
                                  ? AppColors.introNavy
                                  : const Color(0xFF9EA3B0),
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.location_on_outlined,
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
