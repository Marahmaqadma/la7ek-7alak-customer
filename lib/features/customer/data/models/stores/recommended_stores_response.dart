import '../../../domain/entities/suggested_store.dart';

// رد GET api/stores/recommended: صفحة من المتاجر، المطابقة لاهتمامات الزبون أولًا.
class RecommendedStoresResponse {
  final List<RecommendedStoreModel> items;
  final int page;
  final int pageSize;
  final int total;
  final bool hasMore;

  const RecommendedStoresResponse({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.total,
    required this.hasMore,
  });

  factory RecommendedStoresResponse.fromJson(Map<String, dynamic> json) {
    return RecommendedStoresResponse(
      items: ((json['items'] as List?) ?? const [])
          .map((e) => RecommendedStoreModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      hasMore: (json['hasMore'] as bool?) ?? false,
    );
  }
}

// متجر واحد كما يرجعه الخادم. نقرأ فقط الحقول التي تحتاجها الواجهة.
class RecommendedStoreModel {
  final int id;
  final String name;
  final String? imageUrl;
  final String categoryIcon;
  final String area;
  final bool isPreferred;

  const RecommendedStoreModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.categoryIcon,
    required this.area,
    required this.isPreferred,
  });

  factory RecommendedStoreModel.fromJson(Map<String, dynamic> json) {
    final category = json['category'] as Map<String, dynamic>?;
    final city = json['city'] as Map<String, dynamic>?;

    return RecommendedStoreModel(
      id: (json['id'] as num).toInt(),
      name: ((json['name'] as String?) ?? '').trim(),
      // الخادم لا يرجع صورة للمتجر حاليًا؛ نقرأها إن أُضيفت لاحقًا.
      imageUrl:
          (json['logo'] ?? json['logoUrl'] ?? json['imageUrl']) as String?,
      categoryIcon: (category?['icon'] as String?) ?? '',
      area: (city?['area'] as String?) ?? '',
      isPreferred: (json['isPreferred'] as bool?) ?? false,
    );
  }

  SuggestedStore toEntity() => SuggestedStore(
        id: id.toString(),
        name: name,
        imageUrl: imageUrl,
        categoryIcon: categoryIcon,
        isPreferred: isPreferred,
      );
}
