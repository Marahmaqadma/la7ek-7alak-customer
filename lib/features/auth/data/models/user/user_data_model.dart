import 'package:json_annotation/json_annotation.dart';

part 'user_data_model.g.dart';

// نموذج بيانات المستخدم مع تحويل بين JSON وكائنات Dart.
@JsonSerializable()
class UserDataModel {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'fullName')
  final String? fullName;

  @JsonKey(name: 'email')
  final String? email;

  @JsonKey(name: 'role')
  final String? role;

  UserDataModel({this.id, this.fullName, this.email, this.role});

  // يبني النموذج من بيانات JSON القادمة من الخدمة.
  factory UserDataModel.fromJson(Map<String, dynamic> json) =>
      _$UserDataModelFromJson(json);
  // يحوّل الحقول إلى مفاتيح JSON التي تتوقعها الخدمة.
  Map<String, dynamic> toJson() => _$UserDataModelToJson(this);
}
