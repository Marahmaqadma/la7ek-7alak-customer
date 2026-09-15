import 'package:json_annotation/json_annotation.dart';

part 'forgot_password_response.g.dart';

// نتيجة استعادة كلمة المرور القادمة من مصدر المصادقة.
@JsonSerializable(createToJson: false)
class ForgotPasswordResponse {
  final String? message;
  final String? error;

  ForgotPasswordResponse({this.message, this.error});

  // يبني النموذج من بيانات JSON القادمة من الخدمة.
  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordResponseFromJson(json);
}
