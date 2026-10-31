part of 'store_profile_cubit.dart';

enum StoreProfileStatus { initial, loading, loaded, error }

class StoreProfileState {
  final StoreProfileStatus status;
  final StoreProfile? profile;
  // قصص المتجر النشطة (تبويب العروض النشطة، وحلقة الصورة).
  final List<StoryItem> stories;
  final List<StoreAd> ads;
  final String? error;
  // رسالة لمرة واحدة (فشل المتابعة مثلًا) تعرضها الواجهة كـ SnackBar.
  final String? actionMessage;

  const StoreProfileState({
    this.status = StoreProfileStatus.initial,
    this.profile,
    this.stories = const [],
    this.ads = const [],
    this.error,
    this.actionMessage,
  });

  // قصص المتجر بالشكل الذي تعرضه شاشة القصة.
  StoreStory? get storeStory {
    final p = profile;
    if (p == null || stories.isEmpty) return null;
    return StoreStory(
      storeId: p.id,
      storeName: p.name,
      // بدون صورة للمتجر نستخدم صورة أول قصة في رأس شاشة القصة.
      storeImageUrl: p.imageUrl ?? stories.first.imageUrl,
      location: p.location,
      items: stories,
    );
  }

  StoreProfileState copyWith({
    StoreProfileStatus? status,
    StoreProfile? profile,
    List<StoryItem>? stories,
    List<StoreAd>? ads,
    String? error,
    String? actionMessage,
  }) {
    return StoreProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      stories: stories ?? this.stories,
      ads: ads ?? this.ads,
      error: error ?? this.error,
      actionMessage: actionMessage,
    );
  }
}
