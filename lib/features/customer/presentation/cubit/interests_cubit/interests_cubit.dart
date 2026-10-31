import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/store_category.dart';
import '../../../domain/repositories/customer_repository.dart';

part 'interests_state.dart';

// يدير تحميل التصنيفات، واختيار الزبون لها، وحفظها.
class InterestsCubit extends Cubit<InterestsState> {
  final CustomerRepository customerRepository;
  // true عند فتح الشاشة بعد تسجيل الدخول: إن اختار الزبون سابقًا نتخطاها.
  final bool isOnboarding;

  InterestsCubit(this.customerRepository, {this.isOnboarding = false})
      : super(const InterestsState());

  // يجلب التصنيفات واختيارات الزبون المحفوظة معًا.
  Future<void> loadInterests() async {
    emit(state.copyWith(loadStatus: InterestsLoadStatus.loading));

    // نبدأ الطلبين معًا لتقليل الانتظار (الخادم بطيء عند أول طلب).
    final categoriesFuture = customerRepository.getCategories();
    final interestsFuture = customerRepository.getMyInterests();
    final categoriesResult = await categoriesFuture;
    final interestsResult = await interestsFuture;

    // الزبون ممكن يغادر الشاشة أثناء الانتظار.
    if (isClosed) return;

    categoriesResult.fold(
      (failure) => _emitLoadError(failure.message),
      (categories) => interestsResult.fold(
        (failure) => _emitLoadError(failure.message),
        (selectedIds) {
          // زبون أنهى هالخطوة قبل: ما بنعرضها له مرة ثانية.
          if (isOnboarding && selectedIds.isNotEmpty) {
            emit(state.copyWith(
              loadStatus: InterestsLoadStatus.alreadyCompleted,
            ));
            return;
          }
          emit(state.copyWith(
            loadStatus: InterestsLoadStatus.loaded,
            categories: categories,
            selectedIds: selectedIds.toSet(),
          ));
        },
      ),
    );
  }

  void _emitLoadError(String message) => emit(state.copyWith(
        loadStatus: InterestsLoadStatus.error,
        errorMessage: message,
      ));

  // يضيف التصنيف للاختيارات أو يشيله.
  void toggleInterest(int id) {
    final updated = Set<int>.from(state.selectedIds);
    if (!updated.remove(id)) updated.add(id);

    emit(state.copyWith(
      selectedIds: updated,
      saveStatus: InterestsSaveStatus.idle,
    ));
  }

  // يحفظ الاختيارات الحالية (الخادم يرفض القائمة الفارغة).
  Future<void> saveInterests() async {
    if (state.selectedIds.isEmpty || state.isSaving) return;

    emit(state.copyWith(saveStatus: InterestsSaveStatus.saving));

    final result =
        await customerRepository.saveMyInterests(state.selectedIds.toList());

    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(
        saveStatus: InterestsSaveStatus.error,
        errorMessage: failure.message,
      )),
      (savedIds) => emit(state.copyWith(
        saveStatus: InterestsSaveStatus.success,
        selectedIds: savedIds.toSet(),
      )),
    );
  }
}
