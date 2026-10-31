// حالة متابعة متجر كما يؤكدها الخادم بعد المتابعة أو إلغائها.
class FollowStatus {
  final bool isFollowing;
  // العدد الحقيقي للمتابعين إن أرجعه الخادم.
  final int? followersCount;

  const FollowStatus({required this.isFollowing, this.followersCount});
}
