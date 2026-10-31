import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/city/city_model.dart';

// يربط حساب Firebase بالباك إند: يرسل رمز Firebase ويستلم رمز الباك إند (JWT)
// الذي تستخدمه بقية الطلبات. كلمة المرور لا تُرسل للباك إند أبدًا.
class AuthBackendDataSource {
  final Dio dio;

  AuthBackendDataSource(this.dio);

  // POST api/firebase/session. البيانات اختيارية: تُرسل عند التسجيل ليُحفظ
  // الاسم والجوال والعنوان ونوع الحساب في الباك إند.
  // [role]: consumer | merchant. بدونه يعامل الخادم الحساب كزبون، فيُرفض
  // التاجر من مسارات التجار.
  Future<String> createSession({
    required String firebaseIdToken,
    String? name,
    String? phone,
    String? address,
    String? role,
  }) async {
    final body = <String, dynamic>{
      if (name != null && name.isNotEmpty) 'name': name,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
      if (address != null && address.isNotEmpty) 'address': address,
      if (role != null && role.isNotEmpty) 'role': role,
    };

    final response = await dio.post(
      ApiConstants.firebaseSession,
      data: body,
      // هذا الطلب وحده يحمل رمز Firebase بدل رمز الباك إند المحفوظ.
      options: Options(headers: {'Authorization': 'Bearer $firebaseIdToken'}),
    );

    final data = response.data;
    final token = data is Map
        ? (data['token'] ??
            (data['data'] is Map ? data['data']['token'] : null))
        : null;

    if (token is! String || token.isEmpty) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        message: 'الخادم لم يُرجع رمز الدخول',
      );
    }
    return token;
  }

  // GET api/cities: قائمة المدن (الرد مصفوفة مباشرة).
  Future<List<CityModel>> getCities() async {
    final response = await dio.get(ApiConstants.cities);
    return (response.data as List)
        .map((e) => CityModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
