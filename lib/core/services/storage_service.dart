import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// يحفظ رمز الدخول وبيانات الملف الشخصي في التخزين الآمن على الجهاز.
class StorageService {
  static const _tokenKey = 'auth_token';
  static const _selectedCityKey = 'selected_city';
  static const _userFullNameKey = 'user_full_name';
  static const _profileImagePathKey = 'profile_image_path';
  static const _userRoleKey = 'user_role';

  final FlutterSecureStorage _storage;

  const StorageService({
    FlutterSecureStorage storage = const FlutterSecureStorage(),
  }) : _storage = storage;

  // يحفظ رمز الدخول في التخزين الآمن لاستخدامه في الطلبات المحمية.
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // يقرأ رمز الدخول المحفوظ؛ تكون النتيجة null إن لم يوجد.
  Future<String?> getToken() {
    return _storage.read(key: _tokenKey);
  }

  // يحذف رمز الدخول المحلي فقط؛ لا يستدعي تسجيل الخروج من Firebase.
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // يمسح كل بيانات المستخدم المحفوظة عند تسجيل الخروج، حتى لا تظهر لمستخدم آخر.
  Future<void> clearSession() async {
    await Future.wait([
      _storage.delete(key: _tokenKey),
      _storage.delete(key: _userFullNameKey),
      _storage.delete(key: _selectedCityKey),
      _storage.delete(key: _profileImagePathKey),
      _storage.delete(key: _userRoleKey),
    ]);
  }

  // نوع الحساب (consumer | merchant) عند الدخول، لنفتح الرئيسية الصحيحة
  // تلقائيًا عند إعادة فتح التطبيق.
  Future<void> saveUserRole(String role) async {
    await _storage.write(key: _userRoleKey, value: role);
  }

  Future<String?> getUserRole() {
    return _storage.read(key: _userRoleKey);
  }

  // يحفظ المدينة المختارة لتظهر في الملف الشخصي لاحقًا.
  Future<void> saveSelectedCity(String city) async {
    await _storage.write(key: _selectedCityKey, value: city);
  }

  // يقرأ المدينة المحفوظة، أو يعيد null عند عدم اختيار مدينة.
  Future<String?> getSelectedCity() {
    return _storage.read(key: _selectedCityKey);
  }

  // يحفظ اسم المستخدم لعرضه بعد إعادة فتح الشاشة.
  Future<void> saveUserFullName(String fullName) async {
    await _storage.write(key: _userFullNameKey, value: fullName);
  }

  // يقرأ اسم المستخدم من التخزين المحلي الآمن.
  Future<String?> getUserFullName() {
    return _storage.read(key: _userFullNameKey);
  }

  // يحفظ مسار الصورة على الجهاز؛ لا يرفع ملف الصورة إلى الخادم.
  Future<void> saveProfileImagePath(String path) async {
    await _storage.write(key: _profileImagePathKey, value: path);
  }

  // يقرأ مسار الصورة الشخصية المحفوظ.
  Future<String?> getProfileImagePath() {
    return _storage.read(key: _profileImagePathKey);
  }
}
