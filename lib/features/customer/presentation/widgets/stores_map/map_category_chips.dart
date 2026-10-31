import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

// شرائح التصنيفات فوق الخريطة: المختارة كحلية والباقي رمادية.
class MapCategoryChips extends StatelessWidget {
  final List<({int id, String name})> categories;
  final int? selectedId;
  final ValueChanged<int> onSelected;

  const MapCategoryChips({
    super.key,
    required this.categories,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 30.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: categories.length,
        separatorBuilder: (_, __) => SizedBox(width: 6.w),
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected = category.id == selectedId;
          return GestureDetector(
            onTap: () => onSelected(category.id),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color:
                    selected ? AppColors.navy17244E : const Color(0xFFE6E6E6),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Text(
                category.name,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color:
                      selected ? AppColors.white : AppColors.introSubtitleGrey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
