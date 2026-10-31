import 'story_preview.dart';

// قصص متجر واحد كما تُعرض في شاشة القصة؛ لكل قصة جزء في شريط التقدم.
class StoreStory {
  final String storeId;
  final String storeName;
  final String storeImageUrl;
  final String location;
  final List<StoryItem> items;

  const StoreStory({
    required this.storeId,
    required this.storeName,
    required this.storeImageUrl,
    required this.location,
    required this.items,
  });
}

// قصة واحدة داخل قصص المتجر.
class StoryItem {
  final String id;
  final String imageUrl;
  final String caption;
  final String timeAgo;
  final bool isLiked;
  final bool isViewed;
  // عدد المشاهدات (يظهر على بطاقة العرض في صفحة المتجر).
  final int viewsCount;

  const StoryItem({
    required this.id,
    required this.imageUrl,
    required this.caption,
    required this.timeAgo,
    this.isLiked = false,
    this.isViewed = false,
    this.viewsCount = 0,
  });

  StoryItem copyWith({bool? isLiked, bool? isViewed}) => StoryItem(
        id: id,
        imageUrl: imageUrl,
        caption: caption,
        timeAgo: timeAgo,
        isLiked: isLiked ?? this.isLiked,
        isViewed: isViewed ?? this.isViewed,
        viewsCount: viewsCount,
      );
}

// تحديث قصة واحدة داخل قائمة (للإعجاب والمشاهدة).
extension StoryItemsUpdate on List<StoryItem> {
  List<StoryItem> updateItem(String id, StoryItem Function(StoryItem) update) =>
      [for (final item in this) item.id == id ? update(item) : item];
}

extension StoreStoryPreview on StoreStory {
  StoreStory copyWithItems(List<StoryItem> items) => StoreStory(
        storeId: storeId,
        storeName: storeName,
        storeImageUrl: storeImageUrl,
        location: location,
        items: items,
      );

  // شوهدت كل قصص المتجر؟ (للحلقة الرمادية في شريط القصص)
  bool get isFullyViewed => items.every((item) => item.isViewed);

  StoryPreview toPreview() => StoryPreview(
        storeId: storeId,
        storeName: storeName,
        imageUrl: storeImageUrl,
        isWatched: isFullyViewed,
      );
}
