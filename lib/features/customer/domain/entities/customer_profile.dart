// بيانات الزبون كما تظهر في شاشة "حسابي".
class CustomerProfile {
  final String name;
  final String location;
  final String imageUrl;

  const CustomerProfile({
    required this.name,
    required this.location,
    required this.imageUrl,
  });
}

// إعدادات حساب الزبون وتفضيلات إشعاراته.
class AccountSettings {
  final String fullName;
  final String phone;
  // صورة الزبون؛ null حتى يرفع صورة.
  final String? avatarUrl;
  // اسم المدينة للعرض تحت الاسم في "حسابي"؛ فارغ إن لم تُحدد.
  final String cityName;
  final bool newOffersNotifications;
  final bool expiringOffersNotifications;

  const AccountSettings({
    required this.fullName,
    required this.phone,
    this.avatarUrl,
    this.cityName = '',
    required this.newOffersNotifications,
    required this.expiringOffersNotifications,
  });
}
