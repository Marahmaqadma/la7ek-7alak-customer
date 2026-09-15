import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/forgot_password/forgot_password_request_body.dart';
import '../../../data/models/forgot_password/forgot_password_response.dart';
import '../../../domain/repositories/auth_repository.dart';

part 'forgot_password_state.dart';

// يدير طلب استعادة كلمة المرور وينقل الواجهة بين الانتظار والنجاح والخطأ.
class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {

  final AuthRepository authRepository;

  ForgotPasswordCubit(this.authRepository) : super(ForgotPasswordInitial());

  // يبدأ حالة الانتظار ثم يرسل طلب استعادة كلمة المرور ويصدر حالة النجاح أو الخطأ.
  Future<void> forgotPassword(ForgotPasswordRequestBody body) async {

    emit(ForgotPasswordLoading());

    final result = await authRepository.forgotPassword(body);

    result.fold(
      (errorHandler) => emit(ForgotPasswordError(errorHandler.message)),
      (forgotPasswordResponse) =>
          emit(ForgotPasswordSuccess(forgotPasswordResponse)),
    );
  }
}
