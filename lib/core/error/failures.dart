// نوع مشترك لتمثيل فشل العملية مع رسالة توضح السبب.
abstract class Failure {
  final String message;
  Failure(this.message);
}

// يمثّل فشل العملية بسبب الخادم.
class ServerFailure extends Failure {
  ServerFailure(super.message);
}
