// بيانات صفحة المتجر كما يراها الزبون.
// الصورة ورقم التواصل اختياريان: قد لا يضيفهما التاجر.
class StoreProfile {
  final String id;
  final String name;
  final String? imageUrl;
  final String categoryIcon;
  final String location;
  final String bio;
  final String? phone;
  final int followersCount;
  final int viewsCount;
  final bool isFollowing;
  final bool hasActiveStory;

  const StoreProfile({
    required this.id,
    required this.name,
    this.imageUrl,
    this.categoryIcon = '',
    required this.location,
    required this.bio,
    this.phone,
    required this.followersCount,
    required this.viewsCount,
    this.isFollowing = false,
    this.hasActiveStory = false,
  });

  StoreProfile copyWithActiveStory(bool value) => StoreProfile(
        id: id,
        name: name,
        imageUrl: imageUrl,
        categoryIcon: categoryIcon,
        location: location,
        bio: bio,
        phone: phone,
        followersCount: followersCount,
        viewsCount: viewsCount,
        isFollowing: isFollowing,
        hasActiveStory: value,
      );

  // المتابعة تغيّر الزر وعدد المتابعين معًا. [followersCount]: العدد من الخادم
  // إن توفر، وإلا نزيد/ننقص واحدًا.
  StoreProfile copyWithFollowing(bool following, {int? followersCount}) =>
      StoreProfile(
        id: id,
        name: name,
        imageUrl: imageUrl,
        categoryIcon: categoryIcon,
        location: location,
        bio: bio,
        phone: phone,
        followersCount:
            followersCount ?? this.followersCount + (following ? 1 : -1),
        viewsCount: viewsCount,
        isFollowing: following,
        hasActiveStory: hasActiveStory,
      );
}

// عرض نشط (قصة) في تبويب "العروض النشطة".
class StoreOffer {
  final String id;
  final String imageUrl;
  final int viewsCount;

  const StoreOffer({
    required this.id,
    required this.imageUrl,
    required this.viewsCount,
  });
}

// إعلان في تبويب "الإعلانات".
class StoreAd {
  final String id;
  final String imageUrl;

  const StoreAd({required this.id, required this.imageUrl});
}
