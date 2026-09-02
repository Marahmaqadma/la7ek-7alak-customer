import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/forgot_password/forgot_password_request_body.dart';
import '../../../data/models/forgot_password/forgot_password_response.dart';
import '../../../domain/repositories/auth_repository.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  // هذا Cubit مسؤول فقط عن function إرسال كود التحقق للإيميل.
  final AuthRepository authRepository;

  ForgotPasswordCubit(this.authRepository) : super(ForgotPasswordInitial());

  Future<void> forgotPassword(ForgotPasswordRequestBody body) async {
    // عند الضغط على إرسال الرمز، الواجهة تدخل حالة loading.
    emit(ForgotPasswordLoading());

    // body هنا يحتوي email فقط، ويرسله Repository للباك إند.
    final result = await authRepository.forgotPassword(body);

    // إذا فشل الطلب نرسل Error، وإذا نجح نرسل Success.
    result.fold(
      (errorHandler) => emit(ForgotPasswordError(errorHandler.message)),
      (forgotPasswordResponse) =>
          emit(ForgotPasswordSuccess(forgotPasswordResponse)),
    );
  }
}
