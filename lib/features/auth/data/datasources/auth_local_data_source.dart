import 'package:la7ek_7alak/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  UserModel? _cachedUser;

  @override
  Future<void> cacheUser(UserModel user) async {
    _cachedUser = user;
  }

  @override
  Future<void> clearUser() async {
    _cachedUser = null;
  }

  @override
  Future<UserModel?> getCachedUser() async => _cachedUser;
}
