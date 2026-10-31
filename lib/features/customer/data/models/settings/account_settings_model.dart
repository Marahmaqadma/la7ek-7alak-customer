import '../../../domain/entities/customer_profile.dart';

// رد GET api/me/settings:
// { profile: {id, name, email, phone, address, cityId, city, avatarUrl},
//   notifications: {newOffers, followedStorePosts, expiringFollowedOffers} }
class AccountSettingsModel {
  final String name;
  final String email;
  final String phone;
  final String? avatarUrl;
  final String cityName;
  final bool newOffers;
  final bool expiringFollowedOffers;

  const AccountSettingsModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.cityName,
    required this.newOffers,
    required this.expiringFollowedOffers,
  });

  factory AccountSettingsModel.fromJson(Map<String, dynamic> json) {
    final profile = (json['profile'] as Map<String, dynamic>?) ?? const {};
    final notifications =
        (json['notifications'] as Map<String, dynamic>?) ?? const {};
    return AccountSettingsModel(
      name: ((profile['name'] as String?) ?? '').trim(),
      email: (profile['email'] as String?) ?? '',
      phone: (profile['phone'] as String?) ?? '',
      avatarUrl: profile['avatarUrl'] as String?,
      cityName: _cityName(profile['city'], profile['address']),
      newOffers: (notifications['newOffers'] as bool?) ?? true,
      expiringFollowedOffers:
          (notifications['expiringFollowedOffers'] as bool?) ?? true,
    );
  }

  // city: {id, governorate, area, latitude, longitude, cityName} أو null.
  // بدونها نعرض address (المدينة المرسلة عند التسجيل).
  static String _cityName(dynamic city, dynamic address) {
    if (city is Map && city['area'] is String) {
      return (city['area'] as String).trim();
    }
    if (city is String) return city.trim();
    return address is String ? address.trim() : '';
  }

  AccountSettings toEntity() => AccountSettings(
        fullName: name,
        phone: phone,
        avatarUrl: avatarUrl,
        cityName: cityName,
        newOffersNotifications: newOffers,
        expiringOffersNotifications: expiringFollowedOffers,
      );

  // body لـ PUT api/me/settings (مسطّح، بخلاف شكل الـ GET):
  // {name, phone, cityId?, notifyNewOffers, expiringFollowedOffers}.
  // الرد بنفس شكل الـ GET. المدينة لا تُعدّل من شاشة الإعدادات فلا نرسلها.
  static Map<String, dynamic> toUpdateJson(AccountSettings settings) => {
        'name': settings.fullName,
        'phone': settings.phone,
        'notifyNewOffers': settings.newOffersNotifications,
        'expiringFollowedOffers': settings.expiringOffersNotifications,
      };
}
