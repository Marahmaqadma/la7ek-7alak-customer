import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

import '../common/story_ring_avatar.dart';

const Color _unreadBackground = Color(0xFFFDEFE4);

// بطاقة إشعار: خوخية إن لم يُقرأ وبيضاء إن قُرئ. كل الحالات تأتي من الخارج.
// من اليمين: صورة المتجر (بحلقة إن له قصة لم تُشاهد)، النصوص، ثم زر الجرس.
class NotificationItemCard extends StatelessWidget {
  final String title;
  final String body;
  final String timeAgo;
  final String? imageUrl;
  final bool isRead;
  final bool hasUnviewedStory;
  final bool isStoreNotificationsOn;
  final VoidCallback onTap;
  final VoidCallback onStoryTap;
  final VoidCallback onBellTap;

  const NotificationItemCard({
    super.key,
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.imageUrl,
    required this.isRead,
    required this.hasUnviewedStory,
    required this.isStoreNotificationsOn,
    required this.onTap,
    required this.onStoryTap,
    required this.onBellTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isRead ? AppColors.white : _unreadBackground,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isRead ? const Color(0xFFE2E8F0) : _unreadBackground,
            width: 1.w,
          ),
        ),
        child: Row(
          children: [
            StoryRingAvatar(
              imageUrl: imageUrl,
              placeholder: Icon(Icons.storefront_outlined,
                  size: 22.sp, color: AppColors.navy17244E),
              size: 48.w,
              isViewed: !hasUnviewedStory,
              onTap: onStoryTap,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      color: AppColors.navy17244E,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    body,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      color: AppColors.introSubtitleGrey,
                      fontSize: 10.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    timeAgo,
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      color: AppColors.grey,
                      fontSize: 8.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            _BellButton(isOn: isStoreNotificationsOn, onTap: onBellTap),
          ],
        ),
      ),
    );
  }
}

// جرس كحلي ممتلئ عند تفعيل إشعارات المتجر، وفاتح بجرس مشطوب عند إيقافها.
class _BellButton extends StatelessWidget {
  final bool isOn;
  final VoidCallback onTap;

  const _BellButton({required this.isOn, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 26.w,
        height: 26.w,
        decoration: BoxDecoration(
          color: isOn ? AppColors.navy17244E : _unreadBackground,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isOn ? Icons.notifications : Icons.notifications_off_outlined,
          color: isOn ? AppColors.white : AppColors.navy17244E,
          size: 15.w,
        ),
      ),
    );
  }
}
