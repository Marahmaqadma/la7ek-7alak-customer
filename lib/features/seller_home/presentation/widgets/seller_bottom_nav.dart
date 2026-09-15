import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';

// شريط تنقل التاجر مع تمييز التبويب النشط.
class SellerBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const SellerBottomNav({
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
        border: Border(top: BorderSide(color: Color(0xFFF0E6DC))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _SellerNavItem(
            icon: Icons.home_filled,
            label: 'الرئيسية',
            selected: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _SellerNavItem(
            icon: Icons.add,
            label: 'إضافة عرض',
            selected: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          _SellerNavItem(
            icon: Icons.bar_chart,
            label: 'التقارير',
            selected: currentIndex == 2,
            onTap: () => onTap(2),
          ),
          _SellerNavItem(
            icon: Icons.person,
            label: 'البروفايل',
            selected: currentIndex == 3,
            onTap: () => onTap(3),
          ),
        ],
      ),
    );
  }
}

// عنصر تنقل يعرض عنوانًا وأيقونة ويستدعي إجراء تغيير التبويب.
class _SellerNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SellerNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.selectedOrange : const Color(0xFF5B89A4);

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
                Icon(icon, color: color, size: 20.sp),
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
