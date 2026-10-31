import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';
import 'package:la7ek_7alak/core/utils/helpers.dart';

import '../common/category_icon.dart';
import '../common/story_ring_avatar.dart';

// رأس صفحة المتجر: زر الرجوع، صورة المتجر (بحلقة إن كان له قصة)، الاسم والموقع،
// وزرّا المتابعة والإبلاغ. كل البيانات والتفاعلات من الخارج.
class StoreHeaderWidget extends StatelessWidget {
  final String name;
  // بدون صورة تُعرض أيقونة التصنيف.
  final String? imageUrl;
  final String categoryIcon;
  final String location;
  final bool isFollowing;
  final bool hasActiveStory;
  final VoidCallback onBackPressed;
  final VoidCallback onStoryPressed;
  final VoidCallback onFollowPressed;
  final VoidCallback? onReportPressed;

  const StoreHeaderWidget({
    super.key,
    required this.name,
    required this.imageUrl,
    this.categoryIcon = '',
    required this.location,
    required this.isFollowing,
    required this.hasActiveStory,
    required this.onBackPressed,
    required this.onStoryPressed,
    required this.onFollowPressed,
    this.onReportPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // في الاتجاه العربي يظهر سهم الرجوع متجهًا لليمين.
          GestureDetector(
            onTap: onBackPressed,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Icon(
                Icons.arrow_back,
                size: 20.sp,
                color: AppColors.introNavy,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              // له قصة: إطار برتقالي يدور عند الضغط. بدون قصة: صورة فقط.
              if (hasActiveStory)
                StoryRingAvatar(
                  imageUrl: imageUrl,
                  placeholder: CategoryIcon(
                    icon: categoryIcon,
                    size: 26.w,
                    color: AppColors.orangeF58B1F,
                  ),
                  size: 58.w,
                  isViewed: false,
                  onTap: onStoryPressed,
                )
              else
                CircleAvatar(
                  radius: 29.w,
                  backgroundColor: const Color(0xFFDDE7F5),
                  backgroundImage:
                      imageUrl == null ? null : imageProviderFor(imageUrl!),
                  child: imageUrl == null
                      ? CategoryIcon(
                          icon: categoryIcon,
                          size: 28.w,
                          color: AppColors.orangeF58B1F,
                        )
                      : null,
                ),
              SizedBox(width: 8.w),
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
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.introNavy,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 22.h,
                child: ElevatedButton(
                  onPressed: onFollowPressed,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.introNavy,
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    minimumSize: Size(46.w, 22.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  child: Text(
                    isFollowing ? 'إلغاء المتابعة' : 'متابعة',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // يختفي زر الإبلاغ إن لم يكن هناك ما يُبلَّغ عنه.
              if (onReportPressed != null) ...[
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: onReportPressed,
                  child: Container(
                    width: 22.w,
                    height: 22.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: AppColors.introNavy, width: 1.2.w),
                    ),
                    child: Icon(
                      Icons.priority_high_rounded,
                      size: 12.sp,
                      color: AppColors.introNavy,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
