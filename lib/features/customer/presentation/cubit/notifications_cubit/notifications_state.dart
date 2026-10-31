part of 'notifications_cubit.dart';

enum NotificationsStatus { initial, loading, loaded, error }

class NotificationsState {
  final NotificationsStatus status;
  final List<AppNotification> items;
  final String? error;

  // رسالة لمرة واحدة بعد عملية (زر الجرس) تعرضها الواجهة كـ SnackBar.
  final String? actionMessage;

  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.items = const [],
    this.error,
    this.actionMessage,
  });

  // actionMessage تُمسح إن لم تُمرَّر حتى لا تتكرر الرسالة.
  NotificationsState copyWith({
    NotificationsStatus? status,
    List<AppNotification>? items,
    String? error,
    String? actionMessage,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      items: items ?? this.items,
      error: error ?? this.error,
      actionMessage: actionMessage,
    );
  }
}
