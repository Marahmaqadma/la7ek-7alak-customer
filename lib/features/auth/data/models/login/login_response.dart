import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

// نتيجة تسجيل الدخول القادمة من مصدر المصادقة.
@JsonSerializable(createToJson: false)
@JsonSerializable()
class LoginResponse {
  final String message;
  final String token;
  final UserData user;

  LoginResponse({
    required this.message,
    required this.token,
    required this.user,
  });

  // يبني النموذج من بيانات JSON القادمة من الخدمة.
  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

// معرّف المستخدم النصي واسمه وبريده ودوره كما تعيدها خدمة المصادقة.
@JsonSerializable(createToJson: false)
class UserData {

  final String id;
  @JsonKey(name: 'fullName')
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
  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}
