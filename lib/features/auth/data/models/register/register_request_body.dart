// بيانات طلب إنشاء الحساب التي تُمرر إلى مصدر المصادقة.
class RegisterRequestBody {
  final String fullName;
  final String email;
  final String password;
  final String role;
  final String phone;

  RegisterRequestBody({
    required this.fullName,
    required this.email,
    required this.password,
    required this.role,
    required this.phone,
  });

  // يحوّل الحقول إلى مفاتيح JSON التي تتوقعها الخدمة.
  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'email': email,
        'password': password,
        'role': role,
        'phone': phone,
      };
}
