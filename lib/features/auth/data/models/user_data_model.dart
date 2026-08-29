import 'package:json_annotation/json_annotation.dart';

part 'user_data_model.g.dart';

@JsonSerializable()
class UserDataModel {
  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'fullName')
  final String? fullName;

  @JsonKey(name: 'email')
  final String? email;

  @JsonKey(name: 'role')
  final String? role;

  UserDataModel({this.id, this.fullName, this.email, this.role});

  factory UserDataModel.fromJson(Map<String, dynamic> json) => _$UserDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserDataModelToJson(this);
}