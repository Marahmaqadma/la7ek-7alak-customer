import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/auth_repository.dart';

// يقرر أين يذهب التطبيق بعد السبلاش: المستخدم المسجل يدخل مباشرة لرئيسيته،
// وغيره لشاشة الترحيب. يعمل أثناء تشغيل الفيديو فلا يزيد الانتظار.
// الحالة: null حتى يتقرر، ثم نوع الحساب ('consumer' | 'merchant') أو '' لغير المسجل.
class SplashCubit extends Cubit<String?> {
  final AuthRepository authRepository;

  SplashCubit(this.authRepository) : super(null);

  Future<void> checkSession() async {
    final role = await authRepository.restoreSession();
    if (isClosed) return;
    emit(role ?? '');
  }
}
