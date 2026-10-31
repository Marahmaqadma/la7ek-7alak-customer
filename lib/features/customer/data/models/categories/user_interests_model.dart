import 'category_model.dart';

class UserInterestsModel {
  final List<int> categoryIds;
  final List<CategoryModel> categories;

  const UserInterestsModel({
    required this.categoryIds,
    required this.categories,
  });

  factory UserInterestsModel.fromJson(Map<String, dynamic> json) {
    return UserInterestsModel(
      categoryIds: ((json['categoryIds'] as List?) ?? [])
          .map((e) => (e as num).toInt())
          .toList(),
      categories: ((json['categories'] as List?) ?? [])
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
