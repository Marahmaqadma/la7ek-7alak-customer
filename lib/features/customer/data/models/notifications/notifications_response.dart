import '../../../domain/entities/app_notification.dart';

// رد GET api/notifications: {success, notifications: [...]}.
//
// ⚠️ شكل الإشعار نفسه غير معروف بعد (الخادم يرجع قائمة فارغة حاليًا)، لذا
// NotificationModel يجرب أكثر من اسم محتمل لكل حقل. عند وصول رد حقيقي: ثبّتي الأسماء.
class NotificationsResponse {
  final List<NotificationModel> items;

  const NotificationsResponse({required this.items});

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['notifications'] ?? json['items'] ?? const []) as List;
    return NotificationsResponse(
      items: list
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class NotificationModel {
  final String id;
  final String storeId;
  final String title;
  final String body;
  final String? imageUrl;
  final DateTime createdAt;
  final bool isRead;
  // كتم إشعارات المتجر (زر الجرس). ⚠️ اسم الحقل غير مؤكد بعد.
  final bool isStoreMuted;

  const NotificationModel({
    required this.id,
    required this.storeId,
    required this.title,
    required this.body,
    required this.imageUrl,
    required this.createdAt,
    required this.isRead,
    required this.isStoreMuted,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final store = json['store'] as Map<String, dynamic>?;
    return NotificationModel(
      id: '${json['id']}',
      storeId: '${json['storeId'] ?? store?['id'] ?? ''}',
      title: (json['title'] ?? '') as String,
      body:
          (json['body'] ?? json['message'] ?? json['content'] ?? '') as String,
      imageUrl: (store?['logo'] ??
          store?['logoUrl'] ??
          json['imageUrl'] ??
          json['image']) as String?,
      createdAt: DateTime.tryParse('${json['createdAt']}') ?? DateTime.now(),
      isRead: (json['isRead'] ?? json['read'] ?? false) as bool,
      isStoreMuted: (json['isMuted'] ?? store?['isMuted'] ?? false) as bool,
    );
  }

  AppNotification toEntity() => AppNotification(
        id: id,
        storeId: storeId,
        title: title,
        body: body,
        imageUrl: imageUrl,
        createdAt: createdAt,
        isRead: isRead,
        isStoreNotificationsOn: !isStoreMuted,
      );
}
