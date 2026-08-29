import 'package:dio/dio.dart';

class ErrorHandler {
  late String message;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      message = _handleDioError(error);
    } else {
      message = "حدث خطأ غير متوقع، يرجى المحاولة لاحقاً";
    }
  }

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
}