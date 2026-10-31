import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/customer_repository.dart';

part 'support_state.dart';

// يرسل رسالة الزبون للدعم الفني بعد التحقق منها.
class SupportCubit extends Cubit<SupportState> {
  final CustomerRepository customerRepository;

  SupportCubit(this.customerRepository) : super(const SupportState());

  Future<void> send(String title, String message) async {
    if (state.isSending) return;

    // نفس قيود الخادم، حتى لا نرسل طلبًا نعرف أنه سيُرفض.
    if (title.length < 3 || title.length > 120) {
      emit(state.copyWith(
        actionMessage: 'عنوان الاستفسار مطلوب (3 إلى 120 حرفًا)',
      ));
      return;
    }
    if (message.isEmpty) {
      emit(state.copyWith(actionMessage: 'اكتب تفاصيل الرسالة'));
      return;
    }

    emit(state.copyWith(isSending: true));

    final result = await customerRepository.sendSupportRequest(
      title: title,
      message: message,
    );
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(
        isSending: false,
        actionMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        isSending: false,
        sentCount: state.sentCount + 1,
        actionMessage: 'تم إرسال رسالتك، سنتواصل معك قريبًا',
      )),
    );
  }
}
