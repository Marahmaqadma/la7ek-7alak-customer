import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';
import 'package:la7ek_7alak/core/utils/helpers.dart';

// هيدر "حسابي": الصورة بإطار برتقالي يمينًا، ثم الاسم والموقع، وزر تعديل الصورة يسارًا.
class ProfileHeader extends StatelessWidget {
  final String name;
  final String location;
  final String imageUrl;
  final VoidCallback onEditImageTap;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.onEditImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.introNavy,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15.r),
          bottomRight: Radius.circular(15.r),
        ),
      ),
      padding: EdgeInsets.fromLTRB(18.w, 0, 18.w, 24.h),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(top: 36.h),
          child: Row(
            children: [
              // إطار برتقالي وفراغ أبيض حول الصورة.
              Container(
                width: 80.w,
                height: 80.w,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: AppColors.orangeF58B1F, width: 3.w),
                ),
                child: CircleAvatar(
                  backgroundColor: const Color(0xFFDDE7F5),
                  backgroundImage: imageProviderFor(imageUrl),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    // يختفي سطر الموقع إن لم يتوفر.
                    if (location.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 12.sp,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Material(
                color: Colors.white.withOpacity(0.15),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onEditImageTap,
                  child: SizedBox(
                    width: 36.w,
                    height: 36.w,
                    child: Icon(Icons.edit, color: Colors.white, size: 20.sp),
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
