// قصة متجر كما تظهر في شريط القصص بالرئيسية.
class StoryPreview {
  final String storeId;
  final String storeName;
  final String imageUrl;
  final bool isWatched;

  const StoryPreview({
    required this.storeId,
    required this.storeName,
    required this.imageUrl,
    this.isWatched = false,
  });
}
