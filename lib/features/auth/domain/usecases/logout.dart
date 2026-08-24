import 'package:la7ek_7alak/features/auth/domain/repositories/auth_repository.dart';

class Logout {
  final AuthRepository repository;

  const Logout(this.repository);

  Future<void> call() {
    return repository.logout();
  }
}
