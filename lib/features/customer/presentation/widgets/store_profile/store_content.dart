import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';
import 'package:la7ek_7alak/core/utils/helpers.dart';

import '../../../domain/entities/store_profile.dart';

// محتوى التبويب المختار: شبكة العروض النشطة (3 أعمدة) أو قائمة الإعلانات.
class StoreContentWidget extends StatelessWidget {
  // 0: العروض النشطة، 1: الإعلانات
  final int selectedTab;
  final List<StoreOffer> offers;
  final List<StoreAd> ads;
  final ValueChanged<StoreOffer> onOfferTap;

  const StoreContentWidget({
    super.key,
    required this.selectedTab,
    required this.offers,
    required this.ads,
    required this.onOfferTap,
  });

  @override
  Widget build(BuildContext context) {
    final isOffersTab = selectedTab == 0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isOffersTab ? 'العروض النشطة' : 'الإعلانات',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.introNavy,
            ),
          ),
          SizedBox(height: 12.h),
          if (isOffersTab) _buildOffersGrid() else _buildAdsList(),
        ],
      ),
    );
  }

  Widget _buildOffersGrid() {
    if (offers.isEmpty) return _emptyText('لا توجد عروض نشطة حاليًا');

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: offers.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4.w,
        mainAxisSpacing: 4.w,
        childAspectRatio: 0.6,
      ),
      itemBuilder: (context, index) {
        final offer = offers[index];
        return GestureDetector(
          onTap: () => onOfferTap(offer),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image(
                    image: imageProviderFor(offer.imageUrl), fit: BoxFit.cover),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    color: Colors.black45,
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                    child: Text(
                      '${offer.viewsCount} مشاهدة',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 8.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAdsList() {
    if (ads.isEmpty) return _emptyText('لا توجد إعلانات حاليًا');

    return Column(
      children: [
        for (final ad in ads)
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: AspectRatio(
              aspectRatio: 343 / 150,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  image: DecorationImage(
                    image: imageProviderFor(ad.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _emptyText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 12.sp,
            color: AppColors.introSubtitleGrey,
          ),
        ),
      ),
    );
  }
}
