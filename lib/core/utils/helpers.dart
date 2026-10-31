import 'package:flutter/widgets.dart';

// يعيد صورة من الإنترنت إن كان المسار رابطًا، وإلا صورة من assets.
// يسمح باستخدام نفس الويدجت مع البيانات التجريبية الآن وبيانات الـ API لاحقًا.
ImageProvider imageProviderFor(String path) {
  if (path.startsWith('http')) return NetworkImage(path);
  return AssetImage(path);
}

// يحوّل وقتًا إلى نص عربي مثل "منذ 5 دقائق". تنسيق للعرض فقط.
String timeAgoArabic(DateTime time, {DateTime? now}) {
  final diff = (now ?? DateTime.now()).difference(time);

  if (diff.inMinutes < 1) return 'الآن';
  if (diff.inMinutes < 60) {
    final m = diff.inMinutes;
    if (m == 1) return 'منذ دقيقة';
    if (m == 2) return 'منذ دقيقتين';
    return m <= 10 ? 'منذ $m دقائق' : 'منذ $m دقيقة';
  }
  if (diff.inHours < 24) {
    final h = diff.inHours;
    if (h == 1) return 'منذ ساعة واحدة';
    if (h == 2) return 'منذ ساعتين';
    return h <= 10 ? 'منذ $h ساعات' : 'منذ $h ساعة';
  }
  final d = diff.inDays;
  if (d == 1) return 'منذ يوم';
  if (d == 2) return 'منذ يومين';
  return d <= 10 ? 'منذ $d أيام' : 'منذ $d يومًا';
}

// يوحّد الحروف العربية المتشابهة ليجد البحث "الاناقة" في "الأناقة":
// أ إ آ ← ا، ة ← ه، ى ← ي، ويحذف التشكيل والتطويل والمسافات الزائدة.
String normalizeArabic(String text) => text
    .trim()
    .toLowerCase()
    .replaceAll(RegExp('[أإآ]'), 'ا')
    .replaceAll('ة', 'ه')
    .replaceAll('ى', 'ي')
    .replaceAll(RegExp('[ً-ْـ]'), '')
    .replaceAll(RegExp(r'\s+'), ' ');

// هل يحتوي [text] على [query] بعد توحيد الحروف؟
bool arabicContains(String text, String query) =>
    normalizeArabic(text).contains(normalizeArabic(query));
