import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';

// تصميم بطاقة توثيق الهاتف؛ لا ينفّذ إدخال الرقم أو توثيقه حاليًا.
class PhoneVerificationCard extends StatelessWidget {
  const PhoneVerificationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AccountCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'رقم الهاتف (للتوثيق)',
            style: TextStyle(
              color: AppColors.darkBrown,
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            height: 33.h,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8F5),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.accentLight),
            ),
          ),
          SizedBox(height: 9.h),
          Row(
            children: [
              Icon(
                Icons.check_box,
                color: AppColors.orange,
                size: 14.sp,
              ),
              SizedBox(width: 5.w),
              Text(
                'يجب أن يحتوي على 10 خانات',
                style: TextStyle(
                  color: AppColors.accentLight,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w500,
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// يعرض عدد المتاجر المتابَعة ومدينة المستخدم.
class FollowedStoresCard extends StatelessWidget {
  final int count;
  final String city;

  const FollowedStoresCard({
    super.key,
    required this.count,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return AccountCard(
      height: 102.h,
      child: Row(
        children: [
          const _StoreIcon(),
          SizedBox(width: 22.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'المتاجر المتابعة',
                  style: TextStyle(
                    color: AppColors.orange,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  'متاجرك المفضلة في $city',
                  style: TextStyle(
                    color: AppColors.hint,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$count',
            style: TextStyle(
              color: AppColors.darkBrown,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// زر يستدعي إجراء الخروج الذي تمرره الصفحة.
class LogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const LogoutButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 47.h,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(
          Icons.logout,
          color: const Color(0xFFFF5A5F),
          size: 18.sp,
        ),
        label: Text(
          'تسجيل الخروج',
          style: TextStyle(
            color: AppColors.orange,
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFFFFE1E1),
          side: const BorderSide(color: Color(0xFFFF5A5F)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }
}

// حاوية مشتركة لشكل بطاقات صفحة الحساب.
class AccountCard extends StatelessWidget {
  final Widget child;
  final double? height;

  const AccountCard({
    super.key,
    required this.child,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: child,
    );
  }
}

// يرسم رمز المتجر المستخدم داخل بطاقة المتاجر المتابَعة.
class _StoreIcon extends StatelessWidget {
  const _StoreIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56.w,
      height: 56.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.merchantBrown,
          width: 2.w,
        ),
      ),
      child: Icon(
        Icons.storefront,
        color: const Color(0xFF5B89A4),
        size: 28.sp,
      ),
    );
  }
}
