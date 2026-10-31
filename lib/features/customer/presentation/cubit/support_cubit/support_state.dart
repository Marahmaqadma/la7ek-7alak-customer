part of 'support_cubit.dart';

class SupportState {
  final bool isSending;
  // يزيد بعد كل إرسال ناجح؛ الواجهة تفرّغ الحقول عند تغيّره.
  final int sentCount;
  // رسالة لمرة واحدة (نجاح/خطأ تحقق/خطأ خادم) تعرضها الواجهة كـ SnackBar.
  final String? actionMessage;

  const SupportState({
    this.isSending = false,
    this.sentCount = 0,
    this.actionMessage,
  });

  SupportState copyWith({
    bool? isSending,
    int? sentCount,
    String? actionMessage,
  }) {
    return SupportState(
      isSending: isSending ?? this.isSending,
      sentCount: sentCount ?? this.sentCount,
      actionMessage: actionMessage,
    );
  }
}
