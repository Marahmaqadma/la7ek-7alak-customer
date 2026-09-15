

// يحمل رمز الدخول والرسالة، ويدعم اسمي token وaccess_token في الرد.
class UserModel {
  final String? token;
  final String? message;

  UserModel({
    this.token,
    this.message,
  });

  // يبني النموذج من بيانات JSON القادمة من الخدمة.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'] ?? json['access_token'],
      message: json['message'],
    );
  }
}
