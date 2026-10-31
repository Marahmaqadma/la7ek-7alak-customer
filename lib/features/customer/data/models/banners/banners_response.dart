import '../../../domain/entities/home_banner.dart';

// رد GET api/banners: {items: [...], total}.
// كل بانر: {id, title, imageUrl, storeId, storeName, expiresAt}.
class BannersResponse {
  final List<BannerModel> items;

  const BannersResponse({required this.items});

  factory BannersResponse.fromJson(Map<String, dynamic> json) {
    return BannersResponse(
      items: ((json['items'] as List?) ?? const [])
          .map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class BannerModel {
  final int id;
  final String title;
  final String imageUrl;
  final int? storeId;
  final String storeName;
  final DateTime? expiresAt;

  const BannerModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.storeId,
    required this.storeName,
    required this.expiresAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: (json['id'] as num).toInt(),
      title: ((json['title'] as String?) ?? '').trim(),
      imageUrl: ((json['imageUrl'] as String?) ?? '').trim(),
      storeId: (json['storeId'] as num?)?.toInt(),
      storeName: ((json['storeName'] as String?) ?? '').trim(),
      expiresAt: DateTime.tryParse('${json['expiresAt']}'),
    );
  }

  HomeBanner toEntity() => HomeBanner(
        imageUrl: imageUrl,
        storeId: storeId?.toString(),
      );
}
