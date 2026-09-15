import 'package:json_annotation/json_annotation.dart';

part 'reset_password_response.g.dart';

// نتيجة تعيين كلمة المرور القادمة من مصدر المصادقة.
@JsonSerializable(createToJson: false)
class ResetPasswordResponse {
  final String? message;
  final String? error;

  ResetPasswordResponse({this.message, this.error});

  // يبني النموذج من بيانات JSON القادمة من الخدمة.
  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordResponseFromJson(json);
}
