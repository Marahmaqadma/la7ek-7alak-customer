import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// شريط تقدم مقسوم لأجزاء، جزء لكل قصة. الجزء الحالي يمتلئ خلال [duration].
// الأنيميشن حالة واجهة؛ رقم القصة الحالية والإيقاف يأتيان من الخارج.
class StoryProgressIndicatorWidget extends StatefulWidget {
  final int segmentCount;
  final int currentIndex;
  final bool isPaused;
  final Duration duration;
  final VoidCallback onSegmentCompleted;

  const StoryProgressIndicatorWidget({
    super.key,
    required this.segmentCount,
    required this.currentIndex,
    required this.isPaused,
    required this.onSegmentCompleted,
    this.duration = const Duration(seconds: 5),
  });

  @override
  State<StoryProgressIndicatorWidget> createState() =>
      _StoryProgressIndicatorWidgetState();
}

class _StoryProgressIndicatorWidgetState
    extends State<StoryProgressIndicatorWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) widget.onSegmentCompleted();
      });
    if (!widget.isPaused) _controller.forward();
  }

  @override
  void didUpdateWidget(covariant StoryProgressIndicatorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // قصة جديدة: نبدأ الجزء من الصفر.
    if (oldWidget.currentIndex != widget.currentIndex) {
      _controller.reset();
    }
    if (widget.isPaused) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(widget.segmentCount, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(1.r),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final double value;
                  if (index < widget.currentIndex) {
                    value = 1;
                  } else if (index == widget.currentIndex) {
                    value = _controller.value;
                  } else {
                    value = 0;
                  }
                  return LinearProgressIndicator(
                    value: value,
                    minHeight: 2.h,
                    backgroundColor: Colors.white.withOpacity(0.4),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                  );
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}
