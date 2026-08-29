class RegisterResponse {
  final String message;
  final UserData user;

  RegisterResponse({required this.message, required this.user});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(
        message: json['message'],
        user: UserData.fromJson(json['user']),
      );
}

class UserData {
  final int id;
  final String fullName;
  final String email;
  final String role;

  UserData({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json['id'],
    fullName: json['fullName'],
    email: json['email'],
    role: json['role'],
  );
}