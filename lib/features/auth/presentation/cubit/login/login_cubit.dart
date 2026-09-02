import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/login/login_request_body.dart';
import '../../../data/models/login/login_response.dart';
import '../../../domain/repositories/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  // Cubit لا يتعامل مع Dio مباشرة، بل يطلب العمل من Repository.
  final AuthRepository authRepository;

  LoginCubit(this.authRepository) : super(LoginInitial());

  void login(LoginRequestBody body) {
    // أول ما المستخدم يضغط login نرسل Loading للواجهة حتى تظهر حالة انتظار.
    emit(LoginLoading());

    // أرسل email/password للـ Repository وانتظر النتيجة.
    authRepository.login(body).then((result) {
      // fold تفصل النتيجة: اليسار خطأ، اليمين نجاح.
      result.fold(
        // إذا حصل خطأ، أرسل LoginError للواجهة مع رسالة الخطأ.
        (errorHandler) => emit(LoginError(errorHandler.message)),
        // إذا نجح login، أرسل LoginSuccess ومعه response.
        (loginResponse) => emit(LoginSuccess(loginResponse)),
      );
    });
  }
}
