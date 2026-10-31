import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/register/register_request_body.dart';
import '../../../data/models/register/register_response.dart';
import '../../../domain/repositories/auth_repository.dart';

part 'register_state.dart';

// يدير طلب إنشاء الحساب وينقل الواجهة بين الانتظار والنجاح والخطأ.
class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository authRepository;

  RegisterCubit(this.authRepository) : super(RegisterInitial());

  // يبدأ حالة الانتظار ثم يرسل طلب إنشاء الحساب ويصدر حالة النجاح أو الخطأ.
  Future<void> register(RegisterRequestBody body) async {
    emit(RegisterLoading());

    final result = await authRepository.register(body);

    // المستخدم ممكن يغادر الشاشة قبل وصول الرد.
    if (isClosed) return;

    result.fold(
      (errorHandler) => emit(RegisterError(errorHandler.message)),
      (registerResponse) => emit(RegisterSuccess(registerResponse)),
    );
  }
}
