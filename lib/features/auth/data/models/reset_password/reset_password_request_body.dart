import 'package:json_annotation/json_annotation.dart';

part 'reset_password_request_body.g.dart';

// بيانات طلب تعيين كلمة المرور التي تُمرر إلى مصدر المصادقة.
@JsonSerializable(createFactory: false)
class ResetPasswordRequestBody {
  final String email;
  @JsonKey(name: 'newPassword')
  final String newPassword;

  ResetPasswordRequestBody({
    required this.email,
    required this.newPassword,
  });

  // يحوّل الحقول إلى مفاتيح JSON التي تتوقعها الخدمة.
  Map<String, dynamic> toJson() => _$ResetPasswordRequestBodyToJson(this);
}
