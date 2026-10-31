import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// أيقونة تصنيف من الخادم بأحد ثلاثة أشكال: كود SVG نفسه، أو رابط ملف SVG،
// أو إيموجي. الـ SVG يُلوَّن بـ [color].
class CategoryIcon extends StatelessWidget {
  final String icon;
  final double size;
  final Color color;

  const CategoryIcon({
    super.key,
    required this.icon,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final trimmed = icon.trim();
    final colorFilter = ColorFilter.mode(color, BlendMode.srcIn);
    // كود SVG تالف أو رابط لا يعمل لا يكسر ما حوله.
    Widget placeholder(BuildContext _) => SizedBox(width: size, height: size);

    if (trimmed.startsWith('<svg') || trimmed.startsWith('<?xml')) {
      return SvgPicture.string(
        trimmed,
        width: size,
        height: size,
        colorFilter: colorFilter,
        placeholderBuilder: placeholder,
      );
    }

    final uri = Uri.tryParse(trimmed);
    final isSvgUrl = uri != null &&
        uri.hasScheme &&
        uri.scheme.startsWith('http') &&
        uri.path.toLowerCase().endsWith('.svg');
    if (isSvgUrl) {
      return SvgPicture.network(
        trimmed,
        width: size,
        height: size,
        colorFilter: colorFilter,
        placeholderBuilder: placeholder,
      );
    }

    return Text(trimmed, style: TextStyle(fontSize: size * 0.85));
  }
}
