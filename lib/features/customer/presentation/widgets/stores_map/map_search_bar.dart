import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

// شريط البحث فوق الخريطة بإطار برتقالي كما في التصميم.
class MapSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const MapSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.orangeF58B1F, width: 1.w),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 13.sp,
                color: AppColors.navy17244E,
              ),
              decoration: InputDecoration(
                hintText: 'البحث من خلال الموقع أو اسم التاجر',
                hintStyle: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.introSubtitleGrey,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          Icon(Icons.search, color: AppColors.introSubtitleGrey, size: 24.sp),
        ],
      ),
    );
  }
}
