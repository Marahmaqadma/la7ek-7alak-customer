import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/verify_otp/verify_otp_request_body.dart';
import '../../../data/models/verify_otp/verify_otp_response.dart';
import '../../../domain/repositories/auth_repository.dart';

part 'verify_otp_state.dart';

// يدير طلب التحقق من الرمز وينقل الواجهة بين الانتظار والنجاح والخطأ.
class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  final AuthRepository authRepository;

  VerifyOtpCubit(this.authRepository) : super(VerifyOtpInitial());

  // يبدأ حالة الانتظار ثم يرسل طلب التحقق من الرمز ويصدر حالة النجاح أو الخطأ.
  Future<void> verifyOtp(VerifyOtpRequestBody body) async {
    emit(VerifyOtpLoading());

    final result = await authRepository.verifyOtp(body);

    // المستخدم ممكن يغادر الشاشة قبل وصول الرد.
    if (isClosed) return;

    result.fold(
      (errorHandler) => emit(VerifyOtpError(errorHandler.message)),
      (verifyOtpResponse) => emit(VerifyOtpSuccess(verifyOtpResponse)),
    );
  }
}
