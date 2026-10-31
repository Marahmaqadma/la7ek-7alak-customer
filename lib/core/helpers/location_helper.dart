import 'package:geolocator/geolocator.dart';

// موقع الجوال بعد التأكد من تشغيل خدمة الموقع وصلاحية التطبيق.
class LocationHelper {
  LocationHelper._();

  // يرمي Exception برسالة عربية تعرضها الواجهة إن تعذر تحديد الموقع.
  static Future<Position> getCurrentLocation() async {
    // الـ GPS مطفأ: نفتح إعدادات الموقع في الجوال ليشغّله الزبون.
    if (!await Geolocator.isLocationServiceEnabled()) {
      await Geolocator.openLocationSettings();
      throw Exception('شغّل خدمة الموقع ثم اضغط زر موقعي مرة أخرى.');
    }
    // نطلب الصلاحية فقط إن لم تكن ممنوحة (تظهر نافذة النظام).
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw Exception('لن نعرض المتاجر القريبة بدون السماح بالموقع.');
    }
    // رفض دائم: النظام لا يعرض النافذة مجددًا، فنفتح إعدادات التطبيق.
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      throw Exception('اسمح للتطبيق بالوصول للموقع من الإعدادات.');
    }
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 20),
    );
  }
}
