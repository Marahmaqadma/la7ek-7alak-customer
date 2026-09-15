part of 'home_cubit.dart';

// بيانات واجهة المستهلك؛ تبقى القيم ثابتة وتُحدّث بإنشاء نسخة جديدة.
class HomeState {

  final String city;

  final String fullName;

  final int selectedTabIndex;

  final String? profileImagePath;

  final int followedStoresCount;

  const HomeState({
    this.city = 'اختر مدينتك',
    this.fullName = 'المستخدم',
    this.selectedTabIndex = 0,
    this.profileImagePath,
    this.followedStoresCount = 0,
  });

  // ينشئ نسخة من الحالة بالقيم الجديدة ويحافظ على بقية القيم.
  HomeState copyWith({
    String? city,
    String? fullName,
    int? selectedTabIndex,
    String? profileImagePath,
    int? followedStoresCount,
  }) {

    return HomeState(
      city: city ?? this.city,
      fullName: fullName ?? this.fullName,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      followedStoresCount: followedStoresCount ?? this.followedStoresCount,
    );
  }
}
