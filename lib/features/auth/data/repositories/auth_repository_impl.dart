import 'package:la7ek_7alak/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:la7ek_7alak/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:la7ek_7alak/features/auth/domain/entities/user.dart';
import 'package:la7ek_7alak/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    final user = await remoteDataSource.login(email: email, password: password);
    await localDataSource.cacheUser(user);
    return user;
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
    await localDataSource.clearUser();
  }

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final user = await remoteDataSource.register(
      name: name,
      email: email,
      password: password,
    );
    await localDataSource.cacheUser(user);
    return user;
  }
}
