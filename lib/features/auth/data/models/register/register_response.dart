// نتيجة إنشاء الحساب القادمة من مصدر المصادقة.
class RegisterResponse {
  final String message;
  final UserData user;

  RegisterResponse({required this.message, required this.user});

  // يبني النموذج من بيانات JSON القادمة من الخدمة.
  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(
        message: json['message'],
        user: UserData.fromJson(json['user']),
      );
}

// معرّف المستخدم النصي واسمه وبريده ودوره كما تعيدها خدمة المصادقة.
class UserData {
  final String id;
  final String fullName;
  final String email;
  final String role;

  UserData({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
  });

  // يبني النموذج من بيانات JSON القادمة من الخدمة.
  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json['id'],
        fullName: json['fullName'],
        email: json['email'],
        role: json['role'],
      );
}
