import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/utils/helpers.dart';

import '../../../domain/entities/home_banner.dart';

// بانر إعلانات قابل للتمرير مع مؤشر للصفحة الحالية.
// البانرات تأتي من الخارج والضغط يُبلّغ للخارج؛ رقم الصفحة الحالية حالة واجهة فقط.
class HomeBannerWidget extends StatefulWidget {
  final List<HomeBanner> banners;
  final ValueChanged<HomeBanner>? onBannerTap;

  const HomeBannerWidget({super.key, required this.banners, this.onBannerTap});

  @override
  State<HomeBannerWidget> createState() => _HomeBannerWidgetState();
}

class _HomeBannerWidgetState extends State<HomeBannerWidget> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final banners = widget.banners;
    if (banners.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SizedBox(
        height: 150.h,
        child: Stack(
          children: [
            PageView.builder(
              itemCount: banners.length,
              onPageChanged: (page) => setState(() => _currentPage = page),
              itemBuilder: (context, index) {
                final banner = banners[index];
                return GestureDetector(
                  onTap: widget.onBannerTap == null
                      ? null
                      : () => widget.onBannerTap!(banner),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      image: DecorationImage(
                        image: imageProviderFor(banner.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
            if (banners.length > 1)
              Positioned(
                bottom: 8.h,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(banners.length, (index) {
                    final isActive = index == _currentPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      width: isActive ? 16.w : 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.white
                            : Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
