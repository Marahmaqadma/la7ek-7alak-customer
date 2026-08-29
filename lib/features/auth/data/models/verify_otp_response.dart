import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_response.g.dart';

@JsonSerializable(createToJson: false)
class VerifyOtpResponse {
  final String? message;
  final String? error;

  VerifyOtpResponse({this.message, this.error});

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpResponseFromJson(json);
}