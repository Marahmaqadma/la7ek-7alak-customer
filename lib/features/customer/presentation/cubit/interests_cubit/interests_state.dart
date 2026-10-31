part of 'interests_cubit.dart';

// حالة تحميل التصنيفات واختيارات الزبون.
enum InterestsLoadStatus { initial, loading, loaded, error, alreadyCompleted }

// حالة طلب حفظ الاختيارات.
enum InterestsSaveStatus { idle, saving, success, error }

class InterestsState {
  final InterestsLoadStatus loadStatus;
  final InterestsSaveStatus saveStatus;
  final List<StoreCategory> categories;
  final Set<int> selectedIds;
  final String? errorMessage;

  const InterestsState({
    this.loadStatus = InterestsLoadStatus.initial,
    this.saveStatus = InterestsSaveStatus.idle,
    this.categories = const [],
    this.selectedIds = const {},
    this.errorMessage,
  });

  bool get isSaving => saveStatus == InterestsSaveStatus.saving;

  // رسالة الخطأ لا تنتقل للحالة التالية، كل حالة جديدة تبدأ بدون خطأ إلا إذا مررناه.
  InterestsState copyWith({
    InterestsLoadStatus? loadStatus,
    InterestsSaveStatus? saveStatus,
    List<StoreCategory>? categories,
    Set<int>? selectedIds,
    String? errorMessage,
  }) {
    return InterestsState(
      loadStatus: loadStatus ?? this.loadStatus,
      saveStatus: saveStatus ?? this.saveStatus,
      categories: categories ?? this.categories,
      selectedIds: selectedIds ?? this.selectedIds,
      errorMessage: errorMessage,
    );
  }
}
