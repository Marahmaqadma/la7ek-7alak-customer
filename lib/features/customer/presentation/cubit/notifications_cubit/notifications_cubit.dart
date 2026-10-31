import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/app_notification.dart';
import '../../../domain/repositories/customer_repository.dart';

part 'notifications_state.dart';

// يدير قائمة إشعارات الزبون.
class NotificationsCubit extends Cubit<NotificationsState> {
  final CustomerRepository customerRepository;

  NotificationsCubit(this.customerRepository)
      : super(const NotificationsState());

  Future<void> load() async {
    emit(state.copyWith(status: NotificationsStatus.loading));

    final result = await customerRepository.getNotifications();

    // الزبون ممكن يغادر الشاشة أثناء الانتظار.
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(
        status: NotificationsStatus.error,
        error: failure.message,
      )),
      (items) => emit(state.copyWith(
        status: NotificationsStatus.loaded,
        items: items,
      )),
    );
  }

  // زر الجرس: يقلب إشعارات المتجر فورًا لكل إشعاراته، ثم يرسل للخادم.
  // إن فشل الطلب (مثلًا الزبون لم يعد متابعًا) يعيد الحالة ويعرض الخطأ.
  Future<void> toggleStoreNotifications(AppNotification notification) async {
    final storeId = notification.storeId;
    if (storeId.isEmpty) return;

    final before = state.items;
    final turnOn = !notification.isStoreNotificationsOn;
    emit(state.copyWith(
        items: _withStoreNotifications(before, storeId, turnOn)));

    final result =
        await customerRepository.setStoreNotificationsMuted(storeId, !turnOn);
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(
        items: before,
        actionMessage: failure.message,
      )),
      (isMuted) => emit(state.copyWith(
        items: _withStoreNotifications(state.items, storeId, !isMuted),
        actionMessage: isMuted
            ? 'تم إيقاف إشعارات هذا المتجر'
            : 'تم تفعيل إشعارات هذا المتجر',
      )),
    );
  }

  List<AppNotification> _withStoreNotifications(
    List<AppNotification> items,
    String storeId,
    bool on,
  ) =>
      [
        for (final n in items)
          n.storeId == storeId ? n.withStoreNotificationsOn(on) : n,
      ];

  // يعلّم الإشعار مقروءًا فورًا (يصير أبيض) ثم يسجّله في الخادم.
  // الفشل لا يزعج الزبون، فلا نعرض خطأ.
  Future<void> markRead(AppNotification notification) async {
    if (notification.isRead) return;
    emit(state.copyWith(
      items: [
        for (final n in state.items)
          n.id == notification.id ? n.markedRead() : n,
      ],
    ));

    await customerRepository.markNotificationRead(notification.id);
  }
}
