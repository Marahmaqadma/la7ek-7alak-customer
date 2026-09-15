import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_response.g.dart';

// نتيجة التحقق من الرمز القادمة من مصدر المصادقة.
@JsonSerializable(createToJson: false)
class VerifyOtpResponse {
  final String? message;
  final String? error;

  VerifyOtpResponse({this.message, this.error});

  // يبني النموذج من بيانات JSON القادمة من الخدمة.
  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpResponseFromJson(json);
}
