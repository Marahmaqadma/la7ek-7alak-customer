import '../../../domain/entities/follow_status.dart';

// رد POST/DELETE api/stores/:storeId/follow.
class FollowResponse {
  final bool isFollowing;
  final int? followersCount;

  const FollowResponse({required this.isFollowing, this.followersCount});

  // [fallbackFollowing]: ما طلبناه، إن لم يرجع الخادم isFollowing.
  factory FollowResponse.fromJson(
    dynamic json, {
    required bool fallbackFollowing,
  }) {
    final map = json is Map<String, dynamic> ? json : const <String, dynamic>{};
    return FollowResponse(
      isFollowing: (map['isFollowing'] as bool?) ?? fallbackFollowing,
      followersCount: (map['followersCount'] as num?)?.toInt(),
    );
  }

  FollowStatus toEntity() => FollowStatus(
        isFollowing: isFollowing,
        followersCount: followersCount,
      );
}
