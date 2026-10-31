class SaveInterestsRequestModel {
  final List<int> categoryIds;

  const SaveInterestsRequestModel({required this.categoryIds});

  Map<String, dynamic> toJson() => {'categoryIds': categoryIds};
}
