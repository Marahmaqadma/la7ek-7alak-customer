import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_request_body.g.dart';

// بيانات طلب التحقق من الرمز التي تُمرر إلى مصدر المصادقة.
@JsonSerializable(createFactory: false)
class VerifyOtpRequestBody {
  final String email;
  final String otp;

  VerifyOtpRequestBody({required this.email, required this.otp});

  // يحوّل الحقول إلى مفاتيح JSON التي تتوقعها الخدمة.
  Map<String, dynamic> toJson() => _$VerifyOtpRequestBodyToJson(this);
}
