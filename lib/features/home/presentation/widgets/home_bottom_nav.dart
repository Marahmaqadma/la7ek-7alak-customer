import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';

// شريط تنقل المستهلك مع إبراز التبويب الحالي.
class HomeBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const HomeBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.h,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFF0E6DC)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _BottomNavItem(
            icon: Icons.home_filled,
            label: 'الرئيسية',
            selected: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _BottomNavItem(
            icon: Icons.storefront,
            label: 'المتابعة',
            selected: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          _BottomNavItem(
            icon: Icons.person,
            label: 'حسابي',
            selected: currentIndex == 2,
            onTap: () => onTap(2),
          ),
        ],
      ),
    );
  }
}

// عنصر واحد في شريط التنقل يرسل رقم التبويب عند الضغط.
class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 74.w,
        height: 55.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (selected)
              Positioned(
                top: 0,
                child: Container(
                  width: 34.w,
                  height: 2.h,
                  decoration: BoxDecoration(
                    color: AppColors.accentLight,
                    borderRadius: BorderRadius.circular(1.r),
                  ),
                ),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: selected
                      ? AppColors.selectedOrange
                      : const Color(0xFF5B89A4),
                  size: 18.sp,
                ),
                SizedBox(height: 4.h),
                Text(
                  label,
                  style: TextStyle(
                    color: selected ? AppColors.selectedOrange : AppColors.hint,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
