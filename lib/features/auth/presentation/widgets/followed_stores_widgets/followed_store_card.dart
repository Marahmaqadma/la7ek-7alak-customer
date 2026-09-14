import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';
import 'store_notifications_control.dart';

// بطاقة المتجر المتابع - تعرض تفاصيل المتجر، شعاره، زر إلغاء المتابعة، وتحكم الإشعارات
class FollowedStoreCard extends StatefulWidget {
  final String storeName;
  final String storeOffer;
  final IconData storeIcon;
  final VoidCallback? onTap; // دالة الضغط على الكارد بالكامل
  final VoidCallback? onStoryTap; // دالة خاصة بالضغط على دائرة الستوري

  final VoidCallback? onUnfollow; // دالة إلغاء المتابعة

  const FollowedStoreCard({
    super.key,
    required this.storeName,
    required this.storeOffer,
    required this.storeIcon,
    this.onTap,
    this.onStoryTap,
    this.onUnfollow, // استقبال الدالة
  });


  @override
  State<FollowedStoreCard> createState() => _FollowedStoreCardState();
}

class _FollowedStoreCardState extends State<FollowedStoreCard> {
  bool _isLoading = false; // متغير حالة التحميل لدائرة الستوري

  @override
  Widget build(BuildContext context) {
    return Container(
      // الهوامش الخارجية للبطاقة
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18.r),
        child: InkWell(
          onTap: widget.onTap, // تفعيل الضغط على الكارد بالكامل
          borderRadius: BorderRadius.circular(18.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // زر إلغاء المتابعة مصغر وأنيق
                    TextButton(
                      onPressed: widget.onUnfollow, // استدعاء الدالة هنا
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.darkBrown,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'إلغاء المتابعة -',
                        style: TextStyle(fontSize: 10.sp, color: AppColors.white),
                      ),
                    ),

                    //قسم تفاصيل المتجر والشعار
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // اسم المطعم وتحته وصف العرض
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // اسم المتجر باللون البرتقالي
                                  Text(
                                    widget.storeName,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.orange,
                                    ),
                                    textAlign: TextAlign.right,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4.h),
                                  //عرض وصف العرض مع الإيموجي
                                  Text(
                                    '${widget.storeOffer.contains('🍕') ? '🍕' : (widget.storeOffer.contains('🍗') ? '🍗' : '📦')}${widget.storeOffer.replaceAll(RegExp(r'[🍕🍗📦]'), '').trim()}',
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: AppColors.grey,
                                    ),
                                    textAlign: TextAlign.right,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10.w),

                            // دائرة الستوري مع تأثير التحميل عند الضغط
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isLoading = true;
                                });

                                Future.delayed(const Duration(seconds: 2), () {
                                  if (mounted) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                });

                                if (widget.onStoryTap != null) {
                                  widget.onStoryTap!();
                                }
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 44.r,
                                    height: 44.r,
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.orange,
                                        width: 2.w,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.orange.withOpacity(0.2),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      widget.storeIcon,
                                      color: AppColors.orange,
                                      size: 22.sp,
                                    ),
                                  ),
                                  if (_isLoading)
                                    SizedBox(
                                      width: 50.r,
                                      height: 50.r,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5.w,
                                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.orange),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                // ويدجت التحكم المخصص لتنبيهات المتجر بالأسفل
                const StoreNotificationsControl(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}