import 'package:url_launcher/url_launcher.dart';

// يفتح تطبيقات الجوال الخارجية للتواصل. يرجع false إن تعذر الفتح
// (مثلًا واتساب غير مثبت) لتعرض الواجهة رسالة.
class ContactLauncher {
  ContactLauncher._();

  // [internationalNumber]: بدون + (مثل 970598842514).
  static Future<bool> openWhatsApp(String internationalNumber) =>
      _open(Uri.parse('https://wa.me/$internationalNumber'));

  static Future<bool> call(String phone) =>
      _open(Uri(scheme: 'tel', path: phone));

  static Future<bool> _open(Uri uri) async {
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }
}
