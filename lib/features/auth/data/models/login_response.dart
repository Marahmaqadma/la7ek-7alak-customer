import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';
@JsonSerializable(createToJson: false)
@JsonSerializable()
class LoginResponse {
  final String message;
  final String token;
  final UserData user;

  LoginResponse({
    required this.message,
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class UserData {
  final int id;
  @JsonKey(name: 'fullName')
  final String fullName;
  final String email;
  final String role;

  UserData({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}