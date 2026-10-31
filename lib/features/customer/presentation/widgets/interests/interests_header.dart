import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

class InterestsHeaderWidget extends StatelessWidget {
  final int selectedCount;
  final int totalCount;

  const InterestsHeaderWidget({
    super.key,
    required this.selectedCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    // نسبة التعبئة = عدد المختار من مجموع التصنيفات.
    final double progress =
        totalCount == 0 ? 0 : (selectedCount / totalCount).clamp(0.0, 1.0);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // الدائرة الزخرفية على حافة الشاشة اليمنى خلف شريط التقدم.
        PositionedDirectional(
          top: 10.h,
          start: -32.w,
          child: Container(
            width: 68.w,
            height: 68.w,
            decoration: const BoxDecoration(
              color: AppColors.decorativePeach,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'حدد اهتماماتك المفضلة',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.introNavy,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'اختر التصنيفات لتخصيص العروض والقصص اليومية',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.introSubtitleGrey,
              ),
            ),
            SizedBox(height: 12.h),
            // مسار رمادي يتعبأ بالبرتقالي من اليمين حسب عدد الاختيارات.
            Container(
              width: double.infinity,
              height: 6.h,
              decoration: BoxDecoration(
                color: AppColors.progressTrackGrey,
                borderRadius: BorderRadius.circular(3.r),
              ),
              alignment: AlignmentDirectional.centerStart,
              child: AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 250),
                widthFactor: progress,
                heightFactor: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.orangeF58B1F,
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
