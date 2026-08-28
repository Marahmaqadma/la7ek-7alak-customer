import 'package:la7ek_7alak/features/auth/domain/entities/user.dart';
import 'package:la7ek_7alak/features/auth/domain/repositories/auth_repository.dart';

class Register {
  final AuthRepository repository;

  const Register(this.repository);

  Future<User> call({
    required String name,
    required String email,
    required String password,
  }) {
    return repository.register(name: name, email: email, password: password);
  }
}
