import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/reset_password_request_body.dart';
import '../../../data/models/reset_password_response.dart';
import '../../../domain/repositories/auth_repository.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  // هذا Cubit مسؤول فقط عن function تغيير كلمة المرور.
  final AuthRepository authRepository;

  ResetPasswordCubit(this.authRepository) : super(ResetPasswordInitial());

  void resetPassword(ResetPasswordRequestBody body) {
    // أخبر الواجهة أن طلب تغيير كلمة المرور بدأ.
    emit(ResetPasswordLoading());

    // body يحتوي email وكلمة المرور الجديدة.
    authRepository.resetPassword(body).then((result) {
      // النتيجة إما رسالة خطأ أو نجاح تغيير كلمة المرور.
      result.fold(
        (errorHandler) => emit(ResetPasswordError(errorHandler.message)),
        (resetPasswordResponse) =>
            emit(ResetPasswordSuccess(resetPasswordResponse)),
      );
    });
  }
}
