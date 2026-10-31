import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/city/city_model.dart';
import '../../../domain/repositories/auth_repository.dart';

part 'cities_state.dart';

// يجلب قائمة المدن من الخادم لحقل المدينة في شاشة التسجيل.
class CitiesCubit extends Cubit<CitiesState> {
  final AuthRepository authRepository;

  CitiesCubit(this.authRepository) : super(const CitiesState());

  Future<void> load() async {
    // القائمة محمّلة أو قيد التحميل: لا داعي لطلب جديد.
    if (state.status == CitiesStatus.loading ||
        state.status == CitiesStatus.loaded) {
      return;
    }
    emit(state.copyWith(status: CitiesStatus.loading));

    final result = await authRepository.getCities();

    // المستخدم ممكن يغادر الشاشة قبل وصول الرد.
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(
        status: CitiesStatus.error,
        error: failure.message,
      )),
      (cities) => emit(state.copyWith(
        status: CitiesStatus.loaded,
        cities: cities,
      )),
    );
  }
}
