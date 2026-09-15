import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

// يحوّل أخطاء الاتصال والمصادقة إلى رسائل يمكن عرضها للمستخدم.
class ErrorHandler {
  late String message;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      message = _handleDioError(error);
    } else if (error is FirebaseAuthException) {

      message = _handleFirebaseAuthError(error);
    } else {
      message = "حدث خطأ غير متوقع، يرجى المحاولة لاحقاً";
    }
  }

  // يختار رسالة مناسبة لنوع خطأ الاتصال أو رد الخادم.
  String _handleDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return "انتهت فترة الاتصال بالخادم";
      case DioExceptionType.badResponse:
        return dioError.response?.data['error'] ?? dioError.response?.data['message'] ?? "حدث خطأ في الخادم";
      case DioExceptionType.cancel:
        return "تم إلغاء الطلب";
      case DioExceptionType.unknown:
        return "تحقق من اتصالك بالإنترنت";
      default:
        return "حدث خطأ غير معروف";
    }
  }

  // يحوّل رمز خطأ Firebase إلى رسالة عربية مفهومة.
  String _handleFirebaseAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return "صيغة البريد الإلكتروني غير صحيحة";
      case 'user-disabled':
        return "تم تعطيل هذا الحساب";
      case 'user-not-found':
        return "لا يوجد حساب مرتبط بهذا البريد الإلكتروني";
      case 'wrong-password':
      case 'invalid-credential':
        return "البريد الإلكتروني أو كلمة المرور غير صحيحة";
      case 'email-already-in-use':
        return "هذا البريد الإلكتروني مستخدم بالفعل";
      case 'weak-password':
        return "كلمة المرور ضعيفة جدًا، اختر كلمة مرور أقوى";
      case 'operation-not-allowed':
        return "تسجيل الدخول بالبريد وكلمة المرور غير مفعّل حاليًا";
      case 'too-many-requests':
        return "عدد محاولات كثير جدًا، حاول لاحقًا";
      case 'network-request-failed':
        return "تحقق من اتصالك بالإنترنت";
      case 'requires-recent-login':
        return "يجب تسجيل الدخول مجددًا لإتمام هذه العملية";
      default:
        return error.message ?? "حدث خطأ في المصادقة، حاول مرة أخرى";
    }
  }
}