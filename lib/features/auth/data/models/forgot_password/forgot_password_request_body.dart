import 'package:json_annotation/json_annotation.dart';

part 'forgot_password_request_body.g.dart';

@JsonSerializable(createFactory: false)
class ForgotPasswordRequestBody {
  final String email;

  ForgotPasswordRequestBody({required this.email});

  Map<String, dynamic> toJson() => _$ForgotPasswordRequestBodyToJson(this);
}
