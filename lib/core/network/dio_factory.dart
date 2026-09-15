import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../services/storage_service.dart';

// يجهّز اتصال HTTP ويضيف رمز الدخول إلى الطلبات المحمية.
class DioFactory {

  final StorageService storageService;

  DioFactory(this.storageService);

  // يضبط عنوان الخدمة والمهل والرؤوس، ويضيف رمز الدخول للطلبات غير العامة.
  Dio createDio() {

    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(minutes: 10),
        sendTimeout: const Duration(minutes: 10),
        receiveTimeout: const Duration(minutes: 10),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        // يمرر طلبات المصادقة العامة مباشرة ويضيف رمز الدخول لبقية الطلبات.
        onRequest: (options, handler) async {

          // هذه المسارات لا تحتاج رمز دخول لأن المستخدم قد لا يكون مسجلًا بعد.
          final authPaths = {
            ApiConstants.login,
            ApiConstants.register,
            ApiConstants.forgotPassword,
            ApiConstants.verifyOtp,
            ApiConstants.resetPassword,
          };

          if (authPaths.contains(options.path)) {
            handler.next(options);
            return;
          }

          // قراءة الرمز عند كل طلب حتى تُستخدم أحدث قيمة محفوظة.
          final token = await storageService.getToken();

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          handler.next(options);
        },
      ),
    );

    return dio;
  }
}
