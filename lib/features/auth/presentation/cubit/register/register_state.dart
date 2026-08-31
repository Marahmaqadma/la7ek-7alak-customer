part of 'register_cubit.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final RegisterResponse registerResponse;

  RegisterSuccess(this.registerResponse);
}

class RegisterError extends RegisterState {
  final String error;

  RegisterError(this.error);
}
