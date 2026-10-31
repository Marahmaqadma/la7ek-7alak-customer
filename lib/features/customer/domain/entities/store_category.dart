// تصنيف متاجر (مطاعم، ملابس، ...) كما يظهر في الاهتمامات وفلتر الخريطة.
// [icon]: كود SVG أو رابط SVG أو إيموجي؛ تعرضه CategoryIcon.
class StoreCategory {
  final int id;
  final String name;
  final String icon;

  const StoreCategory({
    required this.id,
    required this.name,
    required this.icon,
  });
}
