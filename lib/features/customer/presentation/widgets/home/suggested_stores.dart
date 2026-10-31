import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';
import 'package:la7ek_7alak/core/utils/helpers.dart';

import '../../../domain/entities/suggested_store.dart';
import '../common/category_icon.dart';

// قسم "المتاجر المقترحة": بطاقات أفقية فيها زر متابعة وزر إخفاء.
// القائمة تأتي من الخارج، والمتابعة والإخفاء تُبلّغ للخارج.
class SuggestedStoresWidget extends StatelessWidget {
  final List<SuggestedStore> stores;
  final ValueChanged<SuggestedStore> onFollowTap;
  final ValueChanged<SuggestedStore> onDismissTap;
  final ValueChanged<SuggestedStore>? onStoreTap;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const SuggestedStoresWidget({
    super.key,
    required this.stores,
    required this.onFollowTap,
    required this.onDismissTap,
    this.onStoreTap,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorMessage != null;
    if (!isLoading && !hasError && stores.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'المتاجر المقترحة',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.introNavy,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        if (isLoading)
          SizedBox(
            height: 160.h,
            child: const Center(child: CircularProgressIndicator()),
          )
        else if (hasError)
          SizedBox(
            height: 160.h,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 12.sp,
                      color: AppColors.introSubtitleGrey,
                    ),
                  ),
                  if (onRetry != null)
                    TextButton(
                      onPressed: onRetry,
                      child: Text(
                        'إعادة المحاولة',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 12.sp,
                          color: AppColors.introNavy,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          )
        else
          SizedBox(
            height: 160.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              itemCount: stores.length,
              itemBuilder: (context, index) => _SuggestedStoreCard(
                store: stores[index],
                onFollowTap: () => onFollowTap(stores[index]),
                onDismissTap: () => onDismissTap(stores[index]),
                onTap: onStoreTap == null
                    ? null
                    : () => onStoreTap!(stores[index]),
              ),
            ),
          ),
      ],
    );
  }
}

class _SuggestedStoreCard extends StatelessWidget {
  final SuggestedStore store;
  final VoidCallback onFollowTap;
  final VoidCallback onDismissTap;
  final VoidCallback? onTap;

  const _SuggestedStoreCard({
    required this.store,
    required this.onFollowTap,
    required this.onDismissTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // الضغط على البطاقة يفتح صفحة المتجر؛ زرا المتابعة والإخفاء يأخذان أولوية.
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 163.w,
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: const Color(0xFFEFEFEF),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Stack(
          children: [
            // زر الإخفاء في الزاوية العلوية اليمنى.
            PositionedDirectional(
              top: 8.h,
              start: 8.w,
              child: GestureDetector(
                onTap: onDismissTap,
                child: Icon(Icons.close, size: 16.sp, color: Colors.black87),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // بدون صورة: أيقونة تصنيف المتجر.
                    CircleAvatar(
                      radius: 25.r,
                      backgroundColor: Colors.white,
                      backgroundImage: store.imageUrl == null
                          ? null
                          : imageProviderFor(store.imageUrl!),
                      // أيقونة التصنيف SVG أو إيموجي بدل اللوجو الغائب.
                      child: store.imageUrl == null
                          ? CategoryIcon(
                              icon: store.categoryIcon,
                              size: 26.w,
                              color: AppColors.orangeF58B1F,
                            )
                          : null,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      store.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.introNavy,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    SizedBox(
                      width: 87.w,
                      height: 31.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.introNavy,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          padding: EdgeInsets.zero,
                          elevation: 0,
                        ),
                        onPressed: onFollowTap,
                        child: Text(
                          'متابعة',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 11.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
