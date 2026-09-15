import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../cubit/seller_home_cubit.dart';

// بطاقة العرض وصورته وإحصاءاته وزر الحذف والعداد.
class SellerOfferCard extends StatefulWidget {
  final SellerOffer offer;
  final VoidCallback onDelete;

  const SellerOfferCard({
    super.key,
    required this.offer,
    required this.onDelete,
  });

  @override
  State<SellerOfferCard> createState() => _SellerOfferCardState();
}

// يدير عدادًا محليًا يبدأ من 24 ساعة عند إنشاء البطاقة؛ ليس وقت انتهاء محفوظًا.
class _SellerOfferCardState extends State<SellerOfferCard> {
  late Duration remainingTime;
  Timer? timer;

  // يبدأ عدادًا محليًا من 24 ساعة ويحدثه كل ثانية.
  @override
  void initState() {
    super.initState();
    // هذا وقت ابتدائي للعرض المحلي، ويبدأ مجددًا عند إنشاء البطاقة.
    remainingTime = const Duration(hours: 24);
    timer = Timer.periodic(const Duration(seconds: 1), (_) => _countDown());
  }

  // يوقف المؤقت عند إزالة البطاقة لمنع تحديثها بعد إغلاقها.
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // ينقص العداد ثانية واحدة ويوقف المؤقت عند الصفر.
  void _countDown() {
    // إيقاف المؤقت عند نهاية المدة لمنع ظهور وقت سالب.
    if (remainingTime.inSeconds == 0) {
      timer?.cancel();
      return;
    }

    setState(() {
      remainingTime -= const Duration(seconds: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170.h,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: OfferCardImage(
                imagePath: widget.offer.imagePath,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: _TimerBadge(time: _formattedTime),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      widget.offer.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.darkBrown,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      widget.offer.publishedAt,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.hint,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        height: 1,
                      ),
                    ),
                    SizedBox(height: 7.h),
                    Text(
                      widget.offer.views,
                      style: TextStyle(
                        color: AppColors.accentLight,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                    const Spacer(),
                    SellerOfferDeleteButton(onTap: widget.onDelete),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ينسّق الوقت المتبقي بالساعات والدقائق والثواني.
  String get _formattedTime {
    final hours = remainingTime.inHours.toString().padLeft(2, '0');
    final minutes = remainingTime.inMinutes.remainder(60).toString().padLeft(
          2,
          '0',
        );
    final seconds = remainingTime.inSeconds.remainder(60).toString().padLeft(
          2,
          '0',
        );

    return '$hours:$minutes:$seconds';
  }
}

// يعرض صورة العرض من ملفات التطبيق أو من مسار محلي.
class OfferCardImage extends StatelessWidget {
  final String imagePath;

  const OfferCardImage({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        width: 94.w,
        height: 150.h,
        fit: BoxFit.cover,
      );
    }

    final imageFile = File(imagePath);

    if (!imageFile.existsSync()) {
      return Container(
        width: 94.w,
        height: 150.h,
        color: AppColors.surfaceWarm,
        child: Icon(
          Icons.image_not_supported_outlined,
          color: AppColors.orange,
          size: 28.sp,
        ),
      );
    }

    return Image.file(
      imageFile,
      width: 94.w,
      height: 150.h,
      fit: BoxFit.cover,
    );
  }
}

// زر يطلب حذف العرض عبر الإجراء الممرر إلى البطاقة.
class SellerOfferDeleteButton extends StatelessWidget {
  final VoidCallback onTap;

  const SellerOfferDeleteButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 34.h,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFFFFEDED),
          foregroundColor: AppColors.orange,
          side: const BorderSide(color: Color(0xFFFF8D8D)),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.stop_circle,
              color: Colors.redAccent,
              size: 14.sp,
            ),
            SizedBox(width: 5.w),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'إيقاف / إنهاء العرض',
                  maxLines: 1,
                  style: TextStyle(
                    color: AppColors.orange,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// يعرض الوقت المتبقي بتنسيق صغير داخل بطاقة العرض.
class _TimerBadge extends StatelessWidget {
  final String time;

  const _TimerBadge({required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 23.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.merchantBrown,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer,
            color: AppColors.white,
            size: 10.sp,
          ),
          SizedBox(width: 5.w),
          Text(
            'متبقي $time',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 8.sp,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
