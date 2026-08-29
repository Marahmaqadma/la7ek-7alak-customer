//يأخذ بيانات الدخول من الشاشة ويحولها إلى JSON ليفهمها الباك إند
class LoginRequestBody {
  final String email;
  final String password;

  LoginRequestBody({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}