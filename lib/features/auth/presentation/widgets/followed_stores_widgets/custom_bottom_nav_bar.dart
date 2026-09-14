import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  // مؤشر الصفحة الحالية (1 يعني المتابعة هي المفعلة افتراضياً)
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: const Color(0xFFE6DCCF), width: 1.w),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: _buildNavItem(
              icon: Icons.person_outline,
              label: 'حسابي',
              isSelected: _currentIndex == 0,
              onTap: () {
                setState(() {
                  _currentIndex = 0; // تحديد حسابي
                });
              },
            ),
          ),
          Expanded(
            child: _buildNavItem(
              icon: Icons.store,
              label: 'المتابعة',
              isSelected: _currentIndex == 1,
              onTap: () {
                setState(() {
                  _currentIndex = 1; // تحديد المتابعة
                });
              },
            ),
          ),
          Expanded(
            child: _buildNavItem(
              icon: Icons.home_outlined,
              label: 'الرئيسية',
              isSelected: _currentIndex == 2,
              onTap: () {
                setState(() {
                  _currentIndex = 2; // تحديد الرئيسية
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.orange : AppColors.grey,
              size: 24.sp,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: isSelected ? AppColors.orange : AppColors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}