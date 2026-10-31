import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';
import '../../../domain/entities/story_preview.dart';
import '../common/story_ring_avatar.dart';

// قسم "عروض القصص المباشرة": عنوان وزر تصفية وشريط قصص أفقي.
// الترتيب وحالة المشاهدة والتحميل والخطأ تأتي جاهزة من الخارج.
class StoriesSectionWidget extends StatelessWidget {
  final List<StoryPreview> stories;
  final ValueChanged<StoryPreview> onStoryTap;
  final ValueChanged<String> onSelectFilter;
  final VoidCallback onMapTap;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  // نص القائمة الفارغة؛ افتراضيًا "لا توجد قصص نشطة حاليًا".
  final String? emptyText;
  // الفلتر المفعّل (مثل 'interests')؛ null = بدون فلتر.
  final String? activeFilter;

  const StoriesSectionWidget({
    super.key,
    required this.stories,
    required this.onStoryTap,
    required this.onSelectFilter,
    required this.onMapTap,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
    this.emptyText,
    this.activeFilter,
  });

  static const Map<String, String> _filterLabels = {
    'interests': 'الاهتمامات',
    'top_rated': 'الأعلى تقييماً',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'عروض القصص المباشرة',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.introNavy,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: () => _showFilterBottomSheet(context),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  // الزر كحلي ويحمل اسم الفلتر عندما يكون مفعّلًا.
                  decoration: BoxDecoration(
                    color: activeFilter == null
                        ? Colors.grey[200]
                        : AppColors.introNavy,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.filter_alt,
                          size: 14.sp,
                          color: activeFilter == null
                              ? AppColors.introSubtitleGrey
                              : Colors.white),
                      SizedBox(width: 4.w),
                      Text(
                        _filterLabels[activeFilter] ?? 'تصفية',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 11.sp,
                          color: activeFilter == null
                              ? AppColors.introSubtitleGrey
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        // الارتفاع = حجم الدائرة (بالعرض .w) + الاسم تحتها، حتى لا تُقص على الشاشات العريضة.
        SizedBox(
          height: 56.w + 8.h + 24.sp,
          child: _buildContent(),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(errorMessage!, textAlign: TextAlign.center, style: _hintStyle),
            if (onRetry != null)
              GestureDetector(
                onTap: onRetry,
                child: Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: Text(
                    'إعادة المحاولة',
                    style: _hintStyle.copyWith(
                      color: AppColors.introNavy,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }
    if (stories.isEmpty) {
      return Center(
        child: Text(emptyText ?? 'لا توجد قصص نشطة حاليًا', style: _hintStyle),
      );
    }
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      itemCount: stories.length,
      itemBuilder: (context, index) => _StoryAvatar(
        story: stories[index],
        onTap: () => onStoryTap(stories[index]),
      ),
    );
  }

  TextStyle get _hintStyle => TextStyle(
        fontFamily: 'Tajawal',
        fontSize: 12.sp,
        color: AppColors.introSubtitleGrey,
      );

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      // أبيض صافٍ: بدون elevation لا يضيف Material 3 لونًا بنفسجيًا فوقه.
      backgroundColor: Colors.white,
      elevation: 0,
      // يسمح للشيت بالتمرير إن لم يتسع على الشاشات القصيرة.
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) {
        // الشيت يُبنى في سياق جديد، فنعيد تحديد الاتجاه.
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            // مسافة سفلية بقدر أزرار النظام حتى لا يُقص آخر خيار.
            padding: EdgeInsets.fromLTRB(
              20.w,
              20.w,
              20.w,
              20.w + MediaQuery.viewPaddingOf(sheetContext).bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تصفية القصص',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.introNavy,
                  ),
                ),
                SizedBox(height: 15.h),
                _filterTile(
                  sheetContext,
                  icon: Icons.location_on_outlined,
                  title: 'الأقرب إليك',
                  filter: 'nearest',
                  trailing: GestureDetector(
                    onTap: () {
                      Navigator.pop(sheetContext);
                      onMapTap();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC58013).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_on_rounded,
                              size: 16.sp, color: const Color(0xFFC58013)),
                          SizedBox(width: 4.w),
                          Text(
                            'الخريطة',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 10.sp,
                              color: const Color(0xFFC58013),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(),
                _filterTile(
                  sheetContext,
                  icon: Icons.star_border,
                  title: 'الأعلى تقييماً',
                  filter: 'top_rated',
                ),
                const Divider(),
                _filterTile(
                  sheetContext,
                  icon: Icons.favorite_border,
                  title: 'الاهتمامات',
                  filter: 'interests',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _filterTile(
    BuildContext sheetContext, {
    required IconData icon,
    required String title,
    required String filter,
    Widget? trailing,
  }) {
    final isActive = filter == activeFilter;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: const Color(0xFFC58013)),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 14.sp,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      // علامة ✓ على الفلتر المفعّل؛ الضغط عليه مرة ثانية يلغيه.
      trailing: trailing ??
          (isActive
              ? const Icon(Icons.check_circle, color: AppColors.introNavy)
              : null),
      onTap: () {
        Navigator.pop(sheetContext);
        onSelectFilter(filter);
      },
    );
  }
}

// دائرة قصة واحدة: حلقة برتقالية واسم عريض إن لم تُشاهد، ورمادية إن شوهدت.
class _StoryAvatar extends StatelessWidget {
  final StoryPreview story;
  final VoidCallback onTap;

  const _StoryAvatar({required this.story, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isWatched = story.isWatched;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        children: [
          StoryRingAvatar(
            imageUrl: story.imageUrl,
            size: 56.w,
            isViewed: isWatched,
            onTap: onTap,
          ),
          SizedBox(height: 4.h),
          // الضغط على الاسم يفتح القصة أيضًا لكن بدون دوران الإطار.
          GestureDetector(
            onTap: onTap,
            child: SizedBox(
              width: 65.w,
              child: Text(
                story.storeName,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 10.sp,
                  fontWeight: isWatched ? FontWeight.w400 : FontWeight.w700,
                  color: isWatched
                      ? AppColors.introSubtitleGrey
                      : AppColors.introNavy,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
