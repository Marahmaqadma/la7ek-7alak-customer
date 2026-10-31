// بيانات طلب إنشاء الحساب التي تُمرر إلى مصدر المصادقة.
class RegisterRequestBody {
  final String fullName;
  final String email;
  final String password;
  final String role;
  final String phone;
  // المدينة المختارة؛ تُرسل للباك إند كعنوان عند ربط الحساب.
  final String? address;

  RegisterRequestBody({
    required this.fullName,
    required this.email,
    required this.password,
    required this.role,
    required this.phone,
    this.address,
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
