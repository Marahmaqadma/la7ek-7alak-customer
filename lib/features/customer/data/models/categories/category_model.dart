import '../../../domain/entities/store_category.dart';

// تصنيف كما يرجعه GET api/categories: {id, name, icon}.
class CategoryModel {
  final int id;
  final String name;
  final String icon;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: (json['id'] as num).toInt(),
      name: ((json['name'] as String?) ?? '').trim(),
      icon: (json['icon'] as String?) ?? '',
    );
  }

  StoreCategory toEntity() => StoreCategory(id: id, name: name, icon: icon);
}
