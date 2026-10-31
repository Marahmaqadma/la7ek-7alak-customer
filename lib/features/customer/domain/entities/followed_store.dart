// متجر يتابعه الزبون.
// اللوجو اختياري؛ بدونه تظهر أيقونة التصنيف.
class FollowedStore {
  final String id;
  final String name;
  final String? imageUrl;
  final String categoryIcon;
  // سطر وصفي تحت الاسم (آخر عرض إن توفر، وإلا التصنيف والمدينة).
  final String subtitle;
  // وقت آخر عرض؛ null إن لم ينشر المتجر عرضًا.
  final DateTime? latestOfferAt;
  final DateTime? followedAt;

  const FollowedStore({
    required this.id,
    required this.name,
    this.imageUrl,
    this.categoryIcon = '',
    required this.subtitle,
    this.latestOfferAt,
    this.followedAt,
  });
}
