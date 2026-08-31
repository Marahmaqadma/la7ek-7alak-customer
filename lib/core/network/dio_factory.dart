import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../services/storage_service.dart';

class DioFactory {
  // نحتاج StorageService هنا حتى نقدر نقرأ التوكن المحفوظ ونرسله مع الطلبات المحمية.
  final StorageService storageService;

  DioFactory(this.storageService);

  Dio createDio() {
    // هذا هو كائن Dio الأساسي الذي سيستخدمه التطبيق لكل طلبات الـ API.
    // baseUrl يعني أننا نكتب endpoint فقط مثل login بدل الرابط الكامل كل مرة.
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

    // Interceptor يعمل قبل كل request.
    // وظيفته: يضيف التوكن تلقائيا للطلبات التي تحتاج تسجيل دخول.
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // هذه endpoints عامة ولا تحتاج token، لذلك نتركها تذهب مباشرة للسيرفر.
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

          // للطلبات الأخرى: اقرأ التوكن من التخزين الآمن.
          final token = await storageService.getToken();

          // إذا يوجد token، أرسله في الهيدر حتى يعرف السيرفر المستخدم الحالي.
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
