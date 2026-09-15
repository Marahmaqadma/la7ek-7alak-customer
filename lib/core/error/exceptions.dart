// استثناء يحمل رسالة الخطأ القادمة من الخادم.
class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}