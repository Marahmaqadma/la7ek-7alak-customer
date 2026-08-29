import 'package:json_annotation/json_annotation.dart';

part 'reset_password_response.g.dart';

@JsonSerializable(createToJson: false)
class ResetPasswordResponse {
  final String? message;
  final String? error;

  ResetPasswordResponse({this.message, this.error});

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordResponseFromJson(json);
}