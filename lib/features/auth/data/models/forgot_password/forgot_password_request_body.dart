import 'package:json_annotation/json_annotation.dart';

part 'forgot_password_request_body.g.dart';

// بيانات طلب استعادة كلمة المرور التي تُمرر إلى مصدر المصادقة.
@JsonSerializable(createFactory: false)
class ForgotPasswordRequestBody {
  final String email;

  ForgotPasswordRequestBody({required this.email});

  // يحوّل الحقول إلى مفاتيح JSON التي تتوقعها الخدمة.
  Map<String, dynamic> toJson() => _$ForgotPasswordRequestBodyToJson(this);
}
