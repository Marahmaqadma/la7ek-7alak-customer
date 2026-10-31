import '../../../domain/entities/store_profile.dart';

// رد GET api/stores/:storeId/ads: {items, total}.
//
// ⚠️ شكل الإعلان نفسه غير معروف بعد (الخادم يرجع items فارغة حاليًا)، لذا
// نجرب أكثر من اسم محتمل للصورة. عند وصول رد حقيقي: ثبّتي الأسماء.
class StoreAdsResponse {
  final List<StoreAdModel> items;

  const StoreAdsResponse({required this.items});

  factory StoreAdsResponse.fromJson(Map<String, dynamic> json) {
    return StoreAdsResponse(
      items: ((json['items'] as List?) ?? const [])
          .map((e) => StoreAdModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class StoreAdModel {
  final String id;
  final String imageUrl;

  const StoreAdModel({required this.id, required this.imageUrl});

  factory StoreAdModel.fromJson(Map<String, dynamic> json) {
    return StoreAdModel(
      id: '${json['id']}',
      imageUrl: (json['imageUrl'] ??
          json['mediaUrl'] ??
          json['image'] ??
          json['bannerUrl'] ??
          '') as String,
    );
  }

  StoreAd toEntity() => StoreAd(id: id, imageUrl: imageUrl);
}
