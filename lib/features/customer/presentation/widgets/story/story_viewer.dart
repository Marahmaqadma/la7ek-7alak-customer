import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/utils/helpers.dart';

import '../../../domain/entities/store_story.dart';
import 'story_bottom_actions.dart';
import 'story_bottom_text.dart';
import 'story_header_info.dart';
import 'story_progress_indicator.dart';

// عارض قصص متجر واحد: يتنقل بين القصص تلقائيًا أو باللمس، ويتوقف بالضغط المطوّل.
// رقم القصة الحالية والإيقاف حالة واجهة؛ البيانات والإعجاب والمشاركة من الخارج.
class StoryViewerWidget extends StatefulWidget {
  final StoreStory story;
  final ValueChanged<StoryItem> onLikeTap;
  final ValueChanged<StoryItem> onShareTap;
  final VoidCallback onStoreTap;
  final VoidCallback onFinished;
  // يُستدعى كلما ظهرت قصة على الشاشة (لتسجيل المشاهدة).
  final ValueChanged<StoryItem>? onItemShown;
  // قصة يبدأ منها العرض؛ إن لم تُحدد يبدأ من أول قصة لم تُشاهد.
  final String? initialItemId;

  const StoryViewerWidget({
    super.key,
    required this.story,
    required this.onLikeTap,
    required this.onShareTap,
    required this.onStoreTap,
    required this.onFinished,
    this.onItemShown,
    this.initialItemId,
  });

  @override
  State<StoryViewerWidget> createState() => _StoryViewerWidgetState();
}

class _StoryViewerWidgetState extends State<StoryViewerWidget> {
  late int _currentIndex = _firstUnviewedIndex();
  bool _isPaused = false;

  List<StoryItem> get _items => widget.story.items;

  // مثل انستغرام: نبدأ من أول قصة لم تُشاهد، أو من الأولى إن شوهدت كلها.
  int _firstUnviewedIndex() {
    final items = widget.story.items;
    final requested = items.indexWhere((i) => i.id == widget.initialItemId);
    if (requested != -1) return requested;
    final index = items.indexWhere((item) => !item.isViewed);
    return index == -1 ? 0 : index;
  }

  @override
  void initState() {
    super.initState();
    _notifyShown();
  }

  void _notifyShown() {
    if (_items.isEmpty) return;
    widget.onItemShown?.call(_items[_currentIndex]);
  }

  void _next() {
    if (_currentIndex < _items.length - 1) {
      setState(() => _currentIndex++);
      _notifyShown();
    } else {
      widget.onFinished();
    }
  }

  void _previous() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
      _notifyShown();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) return const SizedBox.shrink();
    final item = _items[_currentIndex];

    return GestureDetector(
      // الاتجاه عربي: اللمس على اليسار للقصة التالية، وعلى اليمين للسابقة.
      onTapUp: (details) {
        final isLeftHalf =
            details.globalPosition.dx < MediaQuery.sizeOf(context).width / 2;
        isLeftHalf ? _next() : _previous();
      },
      onLongPressStart: (_) => setState(() => _isPaused = true),
      onLongPressEnd: (_) => setState(() => _isPaused = false),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // الصورة كاملة بدون قص (contain)، وخلفها نسخة مموّهة منها تملأ
          // الفراغ، مثل إنستغرام. cover كان يقرّب الصور العريضة ويقصها.
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Image(
              image: imageProviderFor(item.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          Container(color: Colors.black.withOpacity(0.25)),
          Image(image: imageProviderFor(item.imageUrl), fit: BoxFit.contain),
          // تدرج من الشفاف إلى الكحلي خلف النص والأزرار.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 290.h,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0),
                    const Color(0xFF17244E),
                  ],
                  stops: const [0.0, 0.81],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StoryProgressIndicatorWidget(
                    segmentCount: _items.length,
                    currentIndex: _currentIndex,
                    isPaused: _isPaused,
                    onSegmentCompleted: _next,
                  ),
                  SizedBox(height: 12.h),
                  StoryHeaderInfoWidget(
                    storeName: widget.story.storeName,
                    storeImageUrl: widget.story.storeImageUrl,
                    timeAgo: item.timeAgo,
                    location: widget.story.location,
                    onTap: widget.onStoreTap,
                  ),
                  const Spacer(),
                  StoryBottomTextWidget(text: item.caption),
                  SizedBox(height: 8.h),
                  StoryBottomActionsWidget(
                    isLiked: item.isLiked,
                    onLikeTap: () => widget.onLikeTap(item),
                    onShareTap: () => widget.onShareTap(item),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
