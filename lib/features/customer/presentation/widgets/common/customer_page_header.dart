import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

// هيدر كحلي لصفحات الزبون الداخلية.
// التطبيق عربي: سهم الرجوع على اليمين متجه لليمين (→)، والعنوان بجانبه.
class CustomerPageHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;

  const CustomerPageHeader({
    super.key,
    required this.title,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.navy17244E,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12.r),
          bottomRight: Radius.circular(12.r),
        ),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(top: 28.h),
          child: Row(
            children: [
              // arrow_back ينعكس تلقائيًا في الاتجاه العربي فيظهر (→).
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onBackPressed ?? () => Navigator.maybePop(context),
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.white,
                    size: 26.sp,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    color: AppColors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
