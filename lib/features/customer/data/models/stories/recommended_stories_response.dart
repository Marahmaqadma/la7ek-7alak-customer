import 'package:la7ek_7alak/core/utils/helpers.dart';

import '../../../domain/entities/store_story.dart';

// رد GET api/stories/recommended: صفحة من القصص النشطة، المطابقة للاهتمامات أولًا.
class RecommendedStoriesResponse {
  final List<StoryModel> items;
  final bool hasMore;

  const RecommendedStoriesResponse(
      {required this.items, required this.hasMore});

  factory RecommendedStoriesResponse.fromJson(Map<String, dynamic> json) {
    return RecommendedStoriesResponse(
      items: ((json['items'] as List?) ?? const [])
          .map((e) => StoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasMore: (json['hasMore'] as bool?) ?? false,
    );
  }

  // يجمع القصص حسب المتجر مع الحفاظ على ترتيب الخادم (المطابق أولًا).
  List<StoreStory> toStoreStories() {
    final byStore = <String, List<StoryModel>>{};
    for (final story in items) {
      byStore.putIfAbsent(story.storeId, () => []).add(story);
    }
    return byStore.values.map((stories) {
      final first = stories.first;
      return StoreStory(
        storeId: first.storeId,
        storeName: first.storeName,
        storeImageUrl: first.storeImageUrl ?? first.imageUrl,
        location: first.storeLocation,
        items: stories.map((s) => s.toItem()).toList(),
      );
    }).toList();
  }
}

class StoryModel {
  final String id;
  final String storeId;
  final String storeName;
  final String? storeImageUrl;
  final String storeLocation;
  final String imageUrl;
  final String caption;
  final DateTime? createdAt;
  final bool isViewed;
  final bool isLiked;
  final int viewsCount;

  const StoryModel({
    required this.id,
    required this.storeId,
    required this.storeName,
    required this.storeImageUrl,
    required this.storeLocation,
    required this.imageUrl,
    required this.caption,
    required this.createdAt,
    required this.isViewed,
    required this.isLiked,
    required this.viewsCount,
  });

  // شكل القصة حسب توثيق GET api/stories/:id:
  // {id, title, description, mediaUrl, createdAt, viewsCount, isLiked,
  //  isViewed, store: {id, name, logo, phone, categoryName, cityName}}
  // أول قصة حقيقية (stories/active) وصلت بشكل آخر للمتجر:
  // {storeId, merchant: {storeName, city}} — فنقرأ الشكلين.
  factory StoryModel.fromJson(Map<String, dynamic> json) {
    final store = json['store'] as Map<String, dynamic>?;
    final merchant = json['merchant'] as Map<String, dynamic>?;
    final title = ((json['title'] as String?) ?? '').trim();
    final description = ((json['description'] as String?) ?? '').trim();

    return StoryModel(
      id: '${json['id']}',
      storeId: '${store?['id'] ?? json['storeId'] ?? ''}',
      storeName:
          ((store?['name'] ?? merchant?['storeName']) as String? ?? '').trim(),
      storeImageUrl: store?['logo'] as String?,
      storeLocation:
          ((store?['cityName'] ?? merchant?['city']) as String? ?? '').trim(),
      imageUrl: ((json['mediaUrl'] as String?) ?? '').trim(),
      // العنوان هو نص العرض؛ الوصف بديل إن لم يوجد عنوان.
      caption: title.isNotEmpty ? title : description,
      createdAt: DateTime.tryParse('${json['createdAt']}'),
      isViewed: (json['isViewed'] as bool?) ?? false,
      isLiked: (json['isLiked'] as bool?) ?? false,
      viewsCount: (json['viewsCount'] as num?)?.toInt() ?? 0,
    );
  }

  StoryItem toItem() => StoryItem(
        id: id,
        imageUrl: imageUrl,
        caption: caption,
        timeAgo: createdAt == null ? '' : timeAgoArabic(createdAt!),
        isLiked: isLiked,
        isViewed: isViewed,
        viewsCount: viewsCount,
      );
}
