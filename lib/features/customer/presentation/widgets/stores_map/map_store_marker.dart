import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';
import 'package:la7ek_7alak/core/utils/helpers.dart';

// مقاس علامة المتجر على الخريطة؛ النقطة في طرفها الأيسر على موقع المتجر.
const double mapStoreMarkerWidth = 190;
const double mapStoreMarkerHeight = 58;

// دبوس المتجر: نقطة برتقالية بهالة إن كان عنده عروض نشطة ورمادية إن لم يكن،
// وبجانبها فقاعة فيها الصورة والاسم والمنطقة وعدد العروض.
class MapStoreMarker extends StatelessWidget {
  final String name;
  final String area;
  final String? imageUrl;
  final int activeOffersCount;
  final VoidCallback onTap;

  const MapStoreMarker({
    super.key,
    required this.name,
    required this.area,
    required this.imageUrl,
    required this.activeOffersCount,
    required this.onTap,
  });

  bool get _hasOffers => activeOffersCount > 0;

  @override
  Widget build(BuildContext context) {
    final dotColor =
        _hasOffers ? AppColors.orangeF58B1F : const Color(0xFF5B6B85);

    // ترتيب ثابت من اليسار: النقطة ثم الفقاعة، مثل التصميم.
    return GestureDetector(
      onTap: onTap,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dotColor.withOpacity(0.25),
              ),
              child: Container(
                width: 13,
                height: 13,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: dotColor),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(child: _buildBubble()),
          ],
        ),
      ),
    );
  }

  Widget _buildBubble() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEDED),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: AppColors.introBlueD2E4F5,
              backgroundImage:
                  imageUrl == null ? null : imageProviderFor(imageUrl!),
              child: imageUrl == null
                  ? const Icon(Icons.storefront_outlined,
                      size: 16, color: AppColors.navy17244E)
                  : null,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy17244E,
                    ),
                  ),
                  if (area.isNotEmpty)
                    Text(
                      area,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 8.sp,
                        color: AppColors.introSubtitleGrey,
                      ),
                    ),
                  if (_hasOffers)
                    Text(
                      activeOffersCount == 1
                          ? 'عرض نشط'
                          : '$activeOffersCount عروض نشطة',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 8.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.orangeF58B1F,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
