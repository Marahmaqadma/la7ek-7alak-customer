import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

// شريط التنقل السفلي لشاشات الزبون.
// الفهارس: 0 الحساب، 1 المتابعين، 2 الإشعارات، 3 الرئيسية.
// كما في التصميم: الرئيسية في أقصى اليمين، والعنصر المختار فقط يظهر اسمه.
class BottomNavBarWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  // نقطة برتقالية على أيقونة الإشعارات إن وُجدت إشعارات غير مقروءة.
  final bool hasUnreadNotifications;

  const BottomNavBarWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.hasUnreadNotifications = false,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      // ارتفاع أدنى وليس ثابتًا، حتى لا تُقص الأيقونة والاسم على الشاشات القصيرة أو بالعرض.
      child: Container(
        constraints: BoxConstraints(minHeight: 84.h),
        // مسافة إضافية بقدر أزرار النظام (رجوع/رئيسية) حتى لا تغطي الأيقونات.
        padding: EdgeInsets.only(
          top: 8.h,
          bottom: 8.h + MediaQuery.viewPaddingOf(context).bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              activeIcon: Icons.home,
              inactiveIcon: Icons.home_outlined,
              label: 'الرئيسية',
              index: 3,
            ),
            _buildNavItem(
              activeIcon: Icons.notifications,
              inactiveIcon: Icons.notifications_none,
              label: 'الإشعارات',
              index: 2,
              showBadge: hasUnreadNotifications,
            ),
            _buildNavItem(
              activeIcon: Icons.people,
              inactiveIcon: Icons.people_outline,
              label: 'المتابعين',
              index: 1,
            ),
            _buildNavItem(
              activeIcon: Icons.person,
              inactiveIcon: Icons.person_outline,
              label: 'حسابي',
              index: 0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData activeIcon,
    required IconData inactiveIcon,
    required String label,
    required int index,
    bool showBadge = false,
  }) {
    final bool isSelected = currentIndex == index;
    final icon = Icon(
      isSelected ? activeIcon : inactiveIcon,
      color: isSelected ? AppColors.introNavy : Colors.grey,
      size: 24.sp,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(index),
      child: SizedBox(
        width: 64.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showBadge)
              Stack(
                clipBehavior: Clip.none,
                children: [
                  icon,
                  PositionedDirectional(
                    top: 1.h,
                    end: 2.w,
                    child: Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: AppColors.orangeEF6F0F,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.2),
                      ),
                    ),
                  ),
                ],
              )
            else
              icon,
            if (isSelected) ...[
              SizedBox(height: 2.h),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 10.sp,
                  color: AppColors.introNavy,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
