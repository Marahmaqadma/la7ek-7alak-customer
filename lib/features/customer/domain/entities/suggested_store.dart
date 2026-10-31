// متجر مقترح على الزبون في الرئيسية.
// إن لم تكن له صورة تُعرض أيقونة تصنيفه بدلها.
class SuggestedStore {
  final String id;
  final String name;
  final String? imageUrl;
  final String categoryIcon;
  // من تصنيفات اهتمامات الزبون (يحدده الخادم)؛ يستخدمه فلتر "الاهتمامات".
  final bool isPreferred;

  const SuggestedStore({
    required this.id,
    required this.name,
    this.imageUrl,
    this.categoryIcon = '',
    this.isPreferred = false,
  });
}
