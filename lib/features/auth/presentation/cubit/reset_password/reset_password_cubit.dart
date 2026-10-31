import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/reset_password/reset_password_request_body.dart';
import '../../../data/models/reset_password/reset_password_response.dart';
import '../../../domain/repositories/auth_repository.dart';

part 'reset_password_state.dart';

// يدير طلب تعيين كلمة المرور وينقل الواجهة بين الانتظار والنجاح والخطأ.
class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final AuthRepository authRepository;

  ResetPasswordCubit(this.authRepository) : super(ResetPasswordInitial());

  // يبدأ حالة الانتظار ثم يرسل طلب تعيين كلمة المرور ويصدر حالة النجاح أو الخطأ.
  Future<void> resetPassword(ResetPasswordRequestBody body) async {
    emit(ResetPasswordLoading());

    final result = await authRepository.resetPassword(body);

    // المستخدم ممكن يغادر الشاشة قبل وصول الرد.
    if (isClosed) return;

    result.fold(
      (errorHandler) => emit(ResetPasswordError(errorHandler.message)),
      (resetPasswordResponse) =>
          emit(ResetPasswordSuccess(resetPasswordResponse)),
    );
  }
}
