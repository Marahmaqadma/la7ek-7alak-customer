//  البيانات المرجعة من السيرفر (Response Model)
//يستقبل رد الباك إند القادم كـ JSON ويحوله إلى Dart Objects لاستخدامها بالـ UI
class UserModel {
  final String? token;
  final String? message;

  UserModel({
    this.token,
    this.message,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'] ?? json['access_token'],
      message: json['message'],
    );
  }
}
