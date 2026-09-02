import 'package:json_annotation/json_annotation.dart';

part 'forgot_password_response.g.dart';

@JsonSerializable(createToJson: false)
class ForgotPasswordResponse {
  final String? message;
  final String? error;

  ForgotPasswordResponse({this.message, this.error});

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordResponseFromJson(json);
}
