// إشعار للزبون من متجر يتابعه.
// القائمة تصل مرتبة من الأحدث ومحصورة بآخر 24 ساعة (مسؤولية الباك والـ cubit).
class AppNotification {
  final String id;
  final String storeId;
  final String title;
  final String body;
  // صورة المتجر؛ بدونها تظهر أيقونة متجر.
  final String? imageUrl;
  final DateTime createdAt;
  final bool isRead;
  final bool hasUnviewedStory;
  final bool isStoreNotificationsOn;

  const AppNotification({
    required this.id,
    required this.storeId,
    required this.title,
    required this.body,
    this.imageUrl,
    required this.createdAt,
    this.isRead = false,
    this.hasUnviewedStory = false,
    this.isStoreNotificationsOn = true,
  });

  AppNotification markedRead() => _copyWith(isRead: true);

  AppNotification withStoreNotificationsOn(bool on) =>
      _copyWith(isStoreNotificationsOn: on);

  AppNotification _copyWith({bool? isRead, bool? isStoreNotificationsOn}) =>
      AppNotification(
        id: id,
        storeId: storeId,
        title: title,
        body: body,
        imageUrl: imageUrl,
        createdAt: createdAt,
        isRead: isRead ?? this.isRead,
        hasUnviewedStory: hasUnviewedStory,
        isStoreNotificationsOn:
            isStoreNotificationsOn ?? this.isStoreNotificationsOn,
      );
}
