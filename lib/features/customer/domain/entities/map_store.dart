// متجر على خريطة المتاجر: دبوس في موقعه وفقاعة باسمه ومنطقته.
// الدبوس برتقالي إن كان عنده عروض نشطة، ورمادي إن لم يكن.
class MapStore {
  final String id;
  final String name;
  final String area;
  final String? imageUrl;
  final int? categoryId;
  final int activeOffersCount;
  final double latitude;
  final double longitude;

  const MapStore({
    required this.id,
    required this.name,
    required this.area,
    this.imageUrl,
    this.categoryId,
    this.activeOffersCount = 0,
    required this.latitude,
    required this.longitude,
  });

  bool get hasActiveOffers => activeOffersCount > 0;
}
