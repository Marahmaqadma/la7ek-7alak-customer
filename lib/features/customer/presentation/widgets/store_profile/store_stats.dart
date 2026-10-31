import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

// عدد المشاهدات (يمين) وعدد المتابعين (يسار) تحت رأس المتجر.
class StoreStatsWidget extends StatelessWidget {
  final int viewsCount;
  final int followersCount;

  const StoreStatsWidget({
    super.key,
    required this.viewsCount,
    required this.followersCount,
  });

  @override
  Widget build(BuildContext context) {
    // المشاهدات تحت اسم المتجر تقريبًا، والمتابعين أقرب لمنتصف الشاشة كما في التصميم.
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 88.w, end: 70.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _StatItem(value: viewsCount, label: 'مشاهدة'),
          _StatItem(value: followersCount, label: 'متابع'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final int value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontFamily: 'Tajawal',
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.introNavy,
    );
    return Column(
      children: [
        Text('$value', style: style),
        Text(label, style: style),
      ],
    );
  }
}
