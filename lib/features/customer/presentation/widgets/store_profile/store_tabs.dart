import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

// تبويبا صفحة المتجر: العروض النشطة (يمين) والإعلانات (يسار)، مع خط تحت المختار.
class StoreTabsWidget extends StatelessWidget {
  // 0: العروض النشطة، 1: الإعلانات
  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  const StoreTabsWidget({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 70.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _TabIcon(
            icon: Icons.grid_view_rounded,
            isSelected: selectedTab == 0,
            onTap: () => onTabChanged(0),
          ),
          _TabIcon(
            icon: Icons.local_offer_outlined,
            isSelected: selectedTab == 1,
            onTap: () => onTabChanged(1),
          ),
        ],
      ),
    );
  }
}

class _TabIcon extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabIcon({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 50.w,
        child: Column(
          children: [
            Icon(
              icon,
              size: 24.sp,
              color: isSelected ? AppColors.introNavy : Colors.grey,
            ),
            SizedBox(height: 6.h),
            Container(
              width: 32.w,
              height: 2.h,
              color: isSelected ? AppColors.introNavy : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
