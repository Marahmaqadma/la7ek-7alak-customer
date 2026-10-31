import '../../../domain/entities/map_store.dart';

// رد GET api/stores/map?south&north&west&east: المتاجر داخل حدود الخريطة.
//
// ⚠️ شكل الرد غير معروف بعد (لم نرَ ردًا حقيقيًا)، لذا نقبل قائمة مباشرة أو
// {items} ونجرب أكثر من اسم لبعض الحقول. عند وصول رد حقيقي: ثبّتي الأسماء.
class MapStoresResponse {
  final List<MapStore> stores;

  const MapStoresResponse({required this.stores});

  factory MapStoresResponse.fromJson(dynamic json) {
    final list = json is List
        ? json
        : json is Map
            ? (json['items'] ?? json['stores'] ?? const []) as List
            : const [];
    return MapStoresResponse(
      stores: list
          .whereType<Map<String, dynamic>>()
          .map(_parse)
          .whereType<MapStore>()
          .toList(),
    );
  }

  // متجر بدون إحداثيات لا يظهر على الخريطة.
  static MapStore? _parse(Map<String, dynamic> json) {
    final lat = (json['latitude'] as num?)?.toDouble();
    final lng = (json['longitude'] as num?)?.toDouble();
    if (lat == null || lng == null) return null;

    final city = json['city'];
    final category = json['category'];
    return MapStore(
      id: '${json['id']}',
      name: ((json['name'] as String?) ?? '').trim(),
      area: ((city is Map ? city['area'] : json['cityName']) as String? ?? '')
          .trim(),
      imageUrl: (json['logo'] ?? json['logoUrl']) as String?,
      categoryId:
          ((category is Map ? category['id'] : json['categoryId']) as num?)
              ?.toInt(),
      activeOffersCount: ((json['activeOffersCount'] ??
              json['activeAdsCount'] ??
              json['offersCount'] ??
              0) as num)
          .toInt(),
      latitude: lat,
      longitude: lng,
    );
  }
}
