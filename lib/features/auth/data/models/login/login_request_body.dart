
// بيانات طلب تسجيل الدخول التي تُمرر إلى مصدر المصادقة.
class LoginRequestBody {
  final String email;
  final String password;
  final String? role;

  LoginRequestBody({
    required this.email,
    required this.password,
    this.role,
  });

  // يحوّل الحقول إلى مفاتيح JSON التي تتوقعها الخدمة.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'email': email,
      'password': password,
    };

    if (role != null) {
      json['role'] = role!;
    }

    return json;
  }
}
