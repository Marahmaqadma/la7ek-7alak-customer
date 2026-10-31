import '../../../domain/entities/followed_store.dart';

// رد GET api/stores/following: صفحة من المتاجر التي يتابعها الزبون.
class FollowingStoresResponse {
  final List<FollowingStoreModel> items;
  final bool hasMore;

  const FollowingStoresResponse({required this.items, required this.hasMore});

  factory FollowingStoresResponse.fromJson(Map<String, dynamic> json) {
    return FollowingStoresResponse(
      items: ((json['items'] as List?) ?? const [])
          .map((e) => FollowingStoreModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasMore: (json['hasMore'] as bool?) ?? false,
    );
  }
}

// متجر متابَع: {id, name, logo, phone, followersCount, categoryName, cityName,
// categoryIcon (SVG), followedAt,
// latestOffer: {id, title, mediaUrl, discountPercentage, createdAt} أو null}.
class FollowingStoreModel {
  final int id;
  final String name;
  final String? imageUrl;
  final String categoryIcon;
  final String categoryName;
  final String cityName;
  final String? latestOfferTitle;
  final DateTime? latestOfferAt;
  final DateTime? followedAt;

  const FollowingStoreModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.categoryIcon,
    required this.categoryName,
    required this.cityName,
    required this.latestOfferTitle,
    required this.latestOfferAt,
    required this.followedAt,
  });

  factory FollowingStoreModel.fromJson(Map<String, dynamic> json) {
    final offer = json['latestOffer'] as Map<String, dynamic>?;
    final offerTitle = ((offer?['title'] as String?) ?? '').trim();
    return FollowingStoreModel(
      id: (json['id'] as num).toInt(),
      name: ((json['name'] as String?) ?? '').trim(),
      imageUrl:
          (json['logo'] ?? json['logoUrl'] ?? json['imageUrl']) as String?,
      categoryIcon: (json['categoryIcon'] as String?) ?? '',
      categoryName: ((json['categoryName'] as String?) ?? '').trim(),
      cityName: ((json['cityName'] as String?) ?? '').trim(),
      latestOfferTitle: offerTitle.isEmpty ? null : offerTitle,
      latestOfferAt: DateTime.tryParse('${offer?['createdAt']}'),
      followedAt: DateTime.tryParse('${json['followedAt']}'),
    );
  }

  FollowedStore toEntity() => FollowedStore(
        id: id.toString(),
        name: name,
        imageUrl: imageUrl,
        categoryIcon: categoryIcon,
        // آخر عرض إن وُجد، وإلا التصنيف والمدينة.
        subtitle: latestOfferTitle ??
            [categoryName, cityName].where((p) => p.isNotEmpty).join(' • '),
        latestOfferAt: latestOfferTitle == null ? null : latestOfferAt,
        followedAt: followedAt,
      );
}
