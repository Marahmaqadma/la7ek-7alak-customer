import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/register_request_body.dart';
import '../../../data/models/register_response.dart';
import '../../../domain/repositories/auth_repository.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  // Repository هو المسؤول عن تنفيذ عملية إنشاء الحساب.
  final AuthRepository authRepository;

  RegisterCubit(this.authRepository) : super(RegisterInitial());

  void register(RegisterRequestBody body) {
    // أخبر الواجهة أن إنشاء الحساب بدأ حتى تعرض loading.
    emit(RegisterLoading());

    // أرسل بيانات المستخدم الجديد إلى Repository.
    authRepository.register(body).then((result) {
      // النتيجة إما خطأ أو نجاح.
      result.fold(
        // في حالة الخطأ، أرسل الرسالة للواجهة.
        (errorHandler) => emit(RegisterError(errorHandler.message)),
        // في حالة النجاح، أرسل response للواجهة.
        (registerResponse) => emit(RegisterSuccess(registerResponse)),
      );
    });
  }
}
