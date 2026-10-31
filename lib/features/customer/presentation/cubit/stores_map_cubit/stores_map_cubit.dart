import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la7ek_7alak/core/utils/helpers.dart';

import '../../../../../core/helpers/location_helper.dart';
import '../../../domain/entities/store_category.dart';
import '../../../domain/entities/map_store.dart';
import '../../../domain/repositories/customer_repository.dart';

part 'stores_map_state.dart';

// يدير خريطة المتاجر: يجلب المتاجر كلما تحركت الخريطة، ويفلترها بالتصنيف
// والبحث، ويحدد موقع الزبون.
class StoresMapCubit extends Cubit<StoresMapState> {
  final CustomerRepository customerRepository;
  final Future<({double latitude, double longitude})> Function() _locate;

  Timer? _debounce;
  int _request = 0;

  StoresMapCubit(
    this.customerRepository, {
    Future<({double latitude, double longitude})> Function()? locate,
  })  : _locate = locate ?? _deviceLocation,
        super(const StoresMapState());

  static Future<({double latitude, double longitude})> _deviceLocation() async {
    final position = await LocationHelper.getCurrentLocation();
    return (latitude: position.latitude, longitude: position.longitude);
  }

  // شرائح التصنيفات فوق الخريطة؛ الفشل يخفيها فقط.
  Future<void> loadCategories() async {
    final result = await customerRepository.getCategories();
    if (isClosed) return;
    result.fold(
      (_) {},
      (categories) => emit(state.copyWith(categories: categories)),
    );
  }

  // تُستدعى عند كل تحريك أو تكبير للخريطة. ننتظر توقف الحركة قليلًا حتى
  // لا نرسل طلبًا مع كل إطار، ونتجاهل ردود الحدود القديمة.
  void loadArea({
    required double south,
    required double north,
    required double west,
    required double east,
  }) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      final request = ++_request;
      emit(state.copyWith(status: MapStoresStatus.loading));

      final result = await customerRepository.getMapStores(
        south: south,
        north: north,
        west: west,
        east: east,
      );
      if (isClosed || request != _request) return;

      result.fold(
        (failure) => emit(state.copyWith(
          status: MapStoresStatus.error,
          actionMessage: failure.message,
        )),
        (stores) => emit(state.copyWith(
          status: MapStoresStatus.loaded,
          stores: stores,
        )),
      );
    });
  }

  // الضغط على التصنيف المختار يلغي الفلتر.
  void selectCategory(int categoryId) {
    if (state.selectedCategoryId == categoryId) {
      emit(state.copyWith(clearCategory: true));
    } else {
      emit(state.copyWith(selectedCategoryId: categoryId));
    }
  }

  // البحث محلي باسم المتجر أو منطقته على ما تم تحميله.
  void search(String query) => emit(state.copyWith(query: query));

  // زر "موقعي": يحدد موقع الزبون ويطلب من الواجهة تحريك الكاميرا إليه.
  Future<void> locate() async {
    if (state.locating) return;
    emit(state.copyWith(locating: true));
    try {
      final location = await _locate();
      if (isClosed) return;
      emit(state.copyWith(
        locating: false,
        myLocation: location,
        cameraRequest: state.cameraRequest + 1,
      ));
    } catch (error) {
      if (isClosed) return;
      emit(state.copyWith(
        locating: false,
        actionMessage: error is Exception
            ? error.toString().replaceFirst('Exception: ', '')
            : 'تعذر تحديد موقعك.',
      ));
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
