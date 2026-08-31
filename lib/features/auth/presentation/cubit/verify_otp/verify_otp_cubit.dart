import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/verify_otp_request_body.dart';
import '../../../data/models/verify_otp_response.dart';
import '../../../domain/repositories/auth_repository.dart';

part 'verify_otp_state.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  // هذا Cubit مسؤول فقط عن function التحقق من OTP.
  final AuthRepository authRepository;

  VerifyOtpCubit(this.authRepository) : super(VerifyOtpInitial());

  void verifyOtp(VerifyOtpRequestBody body) {
    // أرسل Loading حتى تعرف الواجهة أن التحقق بدأ.
    emit(VerifyOtpLoading());

    // body يحتوي email و otp المكون من 6 أرقام.
    authRepository.verifyOtp(body).then((result) {
      // إذا السيرفر رفض الرمز نرسل Error، وإذا قبله نرسل Success.
      result.fold(
        (errorHandler) => emit(VerifyOtpError(errorHandler.message)),
        (verifyOtpResponse) => emit(VerifyOtpSuccess(verifyOtpResponse)),
      );
    });
  }
}
