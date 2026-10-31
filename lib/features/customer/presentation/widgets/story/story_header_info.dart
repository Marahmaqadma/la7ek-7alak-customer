import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/utils/helpers.dart';

// صورة المتجر واسمه ووقت القصة وموقعه أعلى شاشة القصة.
class StoryHeaderInfoWidget extends StatelessWidget {
  final String storeName;
  final String storeImageUrl;
  final String timeAgo;
  final String location;
  final VoidCallback onTap;

  const StoryHeaderInfoWidget({
    super.key,
    required this.storeName,
    required this.storeImageUrl,
    required this.timeAgo,
    required this.location,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.w),
              image: DecorationImage(
                image: imageProviderFor(storeImageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '$storeName  ',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: timeAgo,
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                location,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
