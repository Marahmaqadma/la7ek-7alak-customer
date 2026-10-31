part of 'stores_map_cubit.dart';

enum MapStoresStatus { initial, loading, loaded, error }

// حالة خريطة المتاجر: المتاجر داخل الحدود الظاهرة، وفلتر التصنيف والبحث،
// وموقع الزبون عند طلبه.
class StoresMapState {
  final MapStoresStatus status;
  final List<MapStore> stores;
  final List<StoreCategory> categories;
  // null = كل التصنيفات.
  final int? selectedCategoryId;
  final String query;
  final bool locating;
  // موقع الزبون بعد زر "موقعي"؛ null قبله.
  final ({double latitude, double longitude})? myLocation;
  // يزيد عند كل طلب لتحريك الكاميرا لموقع الزبون.
  final int cameraRequest;
  // رسالة لمرة واحدة تعرضها الواجهة كـ SnackBar.
  final String? actionMessage;

  const StoresMapState({
    this.status = MapStoresStatus.initial,
    this.stores = const [],
    this.categories = const [],
    this.selectedCategoryId,
    this.query = '',
    this.locating = false,
    this.myLocation,
    this.cameraRequest = 0,
    this.actionMessage,
  });

  // المتاجر بعد فلتر التصنيف والبحث باسم المتجر أو منطقته.
  List<MapStore> get visibleStores {
    final q = query.trim();
    return stores.where((s) {
      final categoryOk =
          selectedCategoryId == null || s.categoryId == selectedCategoryId;
      final queryOk =
          q.isEmpty || arabicContains(s.name, q) || arabicContains(s.area, q);
      return categoryOk && queryOk;
    }).toList();
  }

  // selectedCategoryId يُمرَّر عبر [clearCategory] لأن null قيمة صالحة.
  // actionMessage تُمسح إن لم تُمرَّر حتى لا تتكرر الرسالة.
  StoresMapState copyWith({
    MapStoresStatus? status,
    List<MapStore>? stores,
    List<StoreCategory>? categories,
    int? selectedCategoryId,
    bool clearCategory = false,
    String? query,
    bool? locating,
    ({double latitude, double longitude})? myLocation,
    int? cameraRequest,
    String? actionMessage,
  }) {
    return StoresMapState(
      status: status ?? this.status,
      stores: stores ?? this.stores,
      categories: categories ?? this.categories,
      selectedCategoryId:
          clearCategory ? null : selectedCategoryId ?? this.selectedCategoryId,
      query: query ?? this.query,
      locating: locating ?? this.locating,
      myLocation: myLocation ?? this.myLocation,
      cameraRequest: cameraRequest ?? this.cameraRequest,
      actionMessage: actionMessage,
    );
  }
}
