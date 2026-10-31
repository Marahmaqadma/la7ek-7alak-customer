import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

class InterestsBottomButtonWidget extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onPressed;
  final bool isLoading;

  const InterestsBottomButtonWidget({
    super.key,
    required this.selectedCount,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = selectedCount > 0 && !isLoading;

    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.introNavy,
          disabledBackgroundColor: AppColors.introNavy.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          elevation: 0,
        ),
        onPressed: isEnabled ? onPressed : null,
        child: isLoading
            ? SizedBox(
                width: 20.w,
                height: 20.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                'حفظ واستمرار ($selectedCount مختارة)',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
      ),
    );
  }
}
