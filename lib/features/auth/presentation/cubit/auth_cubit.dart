import 'package:flutter/foundation.dart';
import 'package:la7ek_7alak/features/auth/domain/usecases/login.dart';
import 'package:la7ek_7alak/features/auth/domain/usecases/logout.dart';
import 'package:la7ek_7alak/features/auth/domain/usecases/register.dart';
import 'package:la7ek_7alak/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends ChangeNotifier {
  final Login loginUseCase;
  final Register registerUseCase;
  final Logout logoutUseCase;

  AuthState state = const AuthState();

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
  });
}
