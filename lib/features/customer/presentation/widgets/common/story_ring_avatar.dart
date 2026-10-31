import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';
import 'package:la7ek_7alak/core/utils/helpers.dart';

// صورة متجر بإطار قصة على طريقة انستغرام:
// - إطار متدرج إن لم تُشاهد القصة، ورمادي رفيع إن شوهدت، مع فراغ أبيض بينه وبين الصورة.
// - عند الضغط تصغر الصورة قليلًا، ثم يتحول الإطار نفسه لذيل متدرج يدور كأنه يحمّل،
//   وبعدها يُستدعى onTap.
// الضغط والتحميل حالة واجهة فقط؛ حالة المشاهدة تأتي من الخارج.
class StoryRingAvatar extends StatefulWidget {
  // بدون صورة يُعرض [placeholder] داخل الدائرة (أيقونة التصنيف مثلًا).
  final String? imageUrl;
  final Widget? placeholder;
  final double size;
  final bool isViewed;
  final VoidCallback onTap;
  final Duration loadingDuration;

  const StoryRingAvatar({
    super.key,
    required this.imageUrl,
    this.placeholder,
    required this.size,
    required this.isViewed,
    required this.onTap,
    this.loadingDuration = const Duration(milliseconds: 1000),
  });

  @override
  State<StoryRingAvatar> createState() => _StoryRingAvatarState();
}

class _StoryRingAvatarState extends State<StoryRingAvatar>
    with SingleTickerProviderStateMixin {
  // لفة كاملة للإطار أثناء التحميل.
  late final AnimationController _spin = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );
  bool _isPressed = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (_isLoading) return;
    setState(() {
      _isPressed = false;
      _isLoading = true;
    });
    _spin.repeat();

    await Future.delayed(widget.loadingDuration);
    if (!mounted) return;

    _spin
      ..stop()
      ..reset();
    setState(() => _isLoading = false);
    widget.onTap();
  }

  void _setPressed(bool value) {
    if (_isLoading || _isPressed == value) return;
    setState(() => _isPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final ringWidth = widget.isViewed && !_isLoading ? 1.5.w : 2.5.w;
    final whiteGap = 2.5.w;

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTap: _handleTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.92 : 1,
        duration: const Duration(milliseconds: 120),
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: AnimatedBuilder(
            animation: _spin,
            builder: (context, child) => CustomPaint(
              painter: _StoryRingPainter(
                isViewed: widget.isViewed,
                isLoading: _isLoading,
                strokeWidth: ringWidth,
                rotation: _spin.value * 2 * math.pi,
              ),
              child: child,
            ),
            // الصورة خارج الأنيميشن حتى تبقى ثابتة أثناء دوران الإطار.
            child: Padding(
              padding: EdgeInsets.all(ringWidth + whiteGap),
              child: CircleAvatar(
                backgroundColor: const Color(0xFFDDE7F5),
                backgroundImage: widget.imageUrl == null
                    ? null
                    : imageProviderFor(widget.imageUrl!),
                child: widget.imageUrl == null ? widget.placeholder : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StoryRingPainter extends CustomPainter {
  final bool isViewed;
  final bool isLoading;
  final double strokeWidth;
  final double rotation;

  _StoryRingPainter({
    required this.isViewed,
    required this.isLoading,
    required this.strokeWidth,
    required this.rotation,
  });

  // تدرج الإطار بألوان التطبيق البرتقالية.
  static const List<Color> _gradient = [
    Color(0xFFFFC94D),
    AppColors.orangeF58B1F,
    AppColors.orangeEF6F0F,
    Color(0xFFC58013),
    Color(0xFFFFC94D),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (isLoading) {
      // ذيل متدرج: يبدأ شفافًا ويقوى حتى رأسه، ويدور حول الصورة.
      paint.shader = SweepGradient(
        colors: [
          AppColors.orangeF58B1F.withOpacity(0),
          const Color(0xFFFFC94D),
          AppColors.orangeEF6F0F,
        ],
        stops: const [0.0, 0.6, 1.0],
        transform: GradientRotation(rotation),
      ).createShader(rect);
      canvas.drawArc(rect, rotation, 2 * math.pi * 0.85, false, paint);
      return;
    }

    if (isViewed) {
      paint.color = AppColors.greyD9D9D9;
    } else {
      paint.shader = const SweepGradient(
        colors: _gradient,
        transform: GradientRotation(-math.pi / 2),
      ).createShader(rect);
    }
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _StoryRingPainter old) =>
      old.isViewed != isViewed ||
      old.isLoading != isLoading ||
      old.strokeWidth != strokeWidth ||
      old.rotation != rotation;
}
