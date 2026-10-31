import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

// نبذة المتجر ورقم التواصل. النبذة تُقص بعد 3 أسطر وتنتهي بـ "المزيد"
// ملتصقة بآخر سطر، ولا يظهر "المزيد" إن كان النص قصيرًا.
// فتح النبذة وطيها حالة واجهة فقط.
class StoreBioWidget extends StatefulWidget {
  final String bio;
  // يختفي سطر رقم التواصل إن لم يتوفر.
  final String? phone;

  const StoreBioWidget({super.key, required this.bio, this.phone});

  @override
  State<StoreBioWidget> createState() => _StoreBioWidgetState();
}

class _StoreBioWidgetState extends State<StoreBioWidget> {
  static const int _collapsedLines = 3;

  bool _isExpanded = false;
  late final TapGestureRecognizer _toggleRecognizer = TapGestureRecognizer()
    ..onTap = () => setState(() => _isExpanded = !_isExpanded);

  @override
  void dispose() {
    _toggleRecognizer.dispose();
    super.dispose();
  }

  TextStyle get _textStyle => TextStyle(
        fontFamily: 'Tajawal',
        fontSize: 11.sp,
        color: AppColors.introNavy,
        height: 1.4,
        fontWeight: FontWeight.w500,
      );

  TextSpan _toggleSpan(String label) => TextSpan(
        text: label,
        recognizer: _toggleRecognizer,
        style: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 10.sp,
          color: AppColors.introSubtitleGrey,
          fontWeight: FontWeight.bold,
        ),
      );

  // تكبير الخط من إعدادات الجهاز؛ يجب أن يطابق القياسُ العرضَ الحقيقي.
  TextScaler _textScaler = TextScaler.noScaling;
  // الخط الافتراضي من الـ theme (فيه تباعد أحرف) يُدمج مع النص عند العرض، فنقيس به أيضًا.
  TextStyle _defaultStyle = const TextStyle();

  bool _fits(TextSpan span, double maxWidth) {
    final painter = TextPainter(
      text: TextSpan(style: _defaultStyle, children: [span]),
      textDirection: TextDirection.rtl,
      textScaler: _textScaler,
      maxLines: _collapsedLines,
    )..layout(maxWidth: maxWidth);
    final fits = !painter.didExceedMaxLines;
    painter.dispose();
    return fits;
  }

  // أطول جزء من النص (عند حدود الكلمات) يتسع مع "... المزيد" في 3 أسطر.
  TextSpan _collapsedSpan(double maxWidth) {
    final words = widget.bio.split(' ');
    var low = 0;
    var high = words.length;
    while (low < high) {
      final mid = (low + high + 1) ~/ 2;
      final candidate = TextSpan(
        style: _textStyle,
        children: [
          TextSpan(text: '${words.take(mid).join(' ')}... '),
          _toggleSpan('المزيد'),
        ],
      );
      if (_fits(candidate, maxWidth)) {
        low = mid;
      } else {
        high = mid - 1;
      }
    }
    return TextSpan(
      style: _textStyle,
      children: [
        TextSpan(text: '${words.take(low).join(' ')}... '),
        _toggleSpan('المزيد'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _textScaler = MediaQuery.textScalerOf(context);
    _defaultStyle = DefaultTextStyle.of(context).style;

    final phone = widget.phone;
    final hasPhone = phone != null && phone.isNotEmpty;
    if (widget.bio.isEmpty && !hasPhone) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // النبذة في التصميم تأخذ تقريبًا نصف عرض الشاشة من اليمين.
          if (widget.bio.isNotEmpty)
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 210.w),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final fullSpan =
                      TextSpan(text: widget.bio, style: _textStyle);
                  final isLong = !_fits(fullSpan, constraints.maxWidth);

                  final TextSpan span;
                  if (!isLong) {
                    span = fullSpan;
                  } else if (_isExpanded) {
                    span = TextSpan(
                      style: _textStyle,
                      children: [
                        TextSpan(text: '${widget.bio} '),
                        _toggleSpan('عرض أقل'),
                      ],
                    );
                  } else {
                    span = _collapsedSpan(constraints.maxWidth);
                  }
                  return Text.rich(span, textScaler: _textScaler);
                },
              ),
            ),
          if (hasPhone) ...[
            SizedBox(height: 4.h),
            Text('رقم التواصل: $phone', style: _textStyle),
          ],
        ],
      ),
    );
  }
}
