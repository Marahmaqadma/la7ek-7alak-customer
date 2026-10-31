import '../../../domain/entities/store_profile.dart';

// رد GET api/stores/:storeId/profile.
class StoreProfileModel {
  final int id;
  final String name;
  final String? description;
  final String? imageUrl;
  final String? phone;
  final String categoryIcon;
  final String area;
  final int followersCount;
  final int viewsCount;
  final bool isFollowing;
  final bool hasActiveStory;

  const StoreProfileModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.phone,
    required this.categoryIcon,
    required this.area,
    required this.followersCount,
    required this.viewsCount,
    required this.isFollowing,
    required this.hasActiveStory,
  });

  factory StoreProfileModel.fromJson(Map<String, dynamic> json) {
    final category = json['category'] as Map<String, dynamic>?;
    final city = json['city'] as Map<String, dynamic>?;

    return StoreProfileModel(
      id: (json['id'] as num).toInt(),
      name: ((json['name'] as String?) ?? '').trim(),
      description: json['description'] as String?,
      // اللوجو؛ null إن لم يرفع التاجر صورة.
      imageUrl:
          (json['logo'] ?? json['logoUrl'] ?? json['imageUrl']) as String?,
      phone: json['phone'] as String?,
      hasActiveStory: (json['hasActiveStory'] as bool?) ?? false,
      categoryIcon: (category?['icon'] as String?) ?? '',
      area: (city?['area'] as String?) ?? '',
      followersCount: (json['followersCount'] as num?)?.toInt() ?? 0,
      viewsCount: (json['viewsCount'] as num?)?.toInt() ?? 0,
      isFollowing: (json['isFollowing'] as bool?) ?? false,
    );
  }

  StoreProfile toEntity() => StoreProfile(
        id: id.toString(),
        name: name,
        imageUrl: imageUrl,
        categoryIcon: categoryIcon,
        location: area,
        bio: description ?? '',
        phone: phone,
        followersCount: followersCount,
        viewsCount: viewsCount,
        isFollowing: isFollowing,
        hasActiveStory: hasActiveStory,
      );
}
