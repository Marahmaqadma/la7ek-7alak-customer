import 'package:la7ek_7alak/features/auth/domain/entities/user.dart';
import 'package:la7ek_7alak/features/auth/domain/repositories/auth_repository.dart';

class Login {
  final AuthRepository repository;

  const Login(this.repository);

  Future<User> call({
    required String email,
    required String password,
  }) {
    return repository.login(email: email, password: password);
  }
}
