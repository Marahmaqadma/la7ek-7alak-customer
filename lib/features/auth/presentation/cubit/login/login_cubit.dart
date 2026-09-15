import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/login/login_request_body.dart';
import '../../../data/models/login/login_response.dart';
import '../../../domain/repositories/auth_repository.dart';

part 'login_state.dart';

// يدير طلب تسجيل الدخول وينقل الواجهة بين الانتظار والنجاح والخطأ.
class LoginCubit extends Cubit<LoginState> {

  final AuthRepository authRepository;

  LoginCubit(this.authRepository) : super(LoginInitial());

  // يبدأ حالة الانتظار ثم يرسل طلب تسجيل الدخول ويصدر حالة النجاح أو الخطأ.
  void login(LoginRequestBody body) {

    emit(LoginLoading());

    authRepository.login(body).then((result) {

      result.fold(

        (errorHandler) => emit(LoginError(errorHandler.message)),

        (loginResponse) => emit(LoginSuccess(loginResponse)),
      );
    });
  }
}
