import 'package:la7ek_7alak/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl();

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    return UserModel(id: '', name: '', email: email);
  }

  @override
  Future<void> logout() async {}

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return UserModel(id: '', name: name, email: email);
  }
}
