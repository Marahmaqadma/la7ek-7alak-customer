part of 'home_cubit.dart';

// حالة تحميل قسم من أقسام الرئيسية (كل قسم يُحمّل بشكل مستقل).
enum SectionStatus { initial, loading, loaded, error }

// حالة رئيسية الزبون. القصص والمتاجر المقترحة من الخادم.
class HomeState {
  final SectionStatus storiesStatus;
  final List<StoreStory> storeStories;
  final String? storiesError;

  final SectionStatus storesStatus;
  final List<SuggestedStore> suggestedStores;
  final String? storesError;

  // بانرات الإعلانات النشطة؛ فارغة تعني إخفاء القسم.
  final List<HomeBanner> banners;

  // عدد الإشعارات غير المقروءة (نقطة على أيقونة الإشعارات).
  final int unreadNotifications;

  // اسم الزبون للهيدر؛ فارغ حتى يصل من الخادم.
  final String userName;

  // نص البحث من الهيدر؛ البحث محلي على ما تم تحميله.
  final String query;

  // فلتر الرئيسية المفعّل: 'interests' أو null (بدون فلتر).
  final String? activeFilter;

  // رسالة لمرة واحدة بعد عملية (متابعة نجحت/فشلت) تعرضها الواجهة كـ SnackBar.
  final String? actionMessage;

  const HomeState({
    this.query = '',
    this.activeFilter,
    this.unreadNotifications = 0,
    this.banners = const [],
    this.userName = '',
    this.storiesStatus = SectionStatus.initial,
    this.storeStories = const [],
    this.storiesError,
    this.storesStatus = SectionStatus.initial,
    this.suggestedStores = const [],
    this.storesError,
    this.actionMessage,
  });

  bool get isSearching => query.trim().isNotEmpty;

  bool get _interestsOnly => activeFilter == 'interests';

  // متاجر اهتمامات الزبون (من المقترحة)؛ القصص لا تحمل تصنيفًا فنفلترها بها.
  Set<String> get _preferredStoreIds => {
        for (final s in suggestedStores)
          if (s.isPreferred) s.id
      };

  // القصص والمتاجر بعد الفلتر والبحث باسم المتجر
  // (البحث بدون فرق بين أ/ا، ة/ه، ى/ي).
  List<StoreStory> get visibleStories {
    final preferred = _interestsOnly ? _preferredStoreIds : const <String>{};
    return storeStories
        .where((s) => !_interestsOnly || preferred.contains(s.storeId))
        .where((s) => !isSearching || arabicContains(s.storeName, query))
        .toList();
  }

  List<SuggestedStore> get visibleStores => suggestedStores
      .where((s) => !_interestsOnly || s.isPreferred)
      .where((s) => !isSearching || arabicContains(s.name, query))
      .toList();

  // actionMessage تُمسح إن لم تُمرَّر حتى لا تتكرر الرسالة. رسائل أخطاء الأقسام
  // تبقى، لأن كل قسم يُحدَّث مستقلًا ولا تُعرض إلا وحالته error.
  // activeFilter يُمرَّر عبر [clearFilter] لأن null قيمة صالحة (بدون فلتر).
  HomeState copyWith({
    String? activeFilter,
    bool clearFilter = false,
    SectionStatus? storiesStatus,
    List<StoreStory>? storeStories,
    String? storiesError,
    SectionStatus? storesStatus,
    List<SuggestedStore>? suggestedStores,
    String? storesError,
    int? unreadNotifications,
    List<HomeBanner>? banners,
    String? userName,
    String? query,
    String? actionMessage,
  }) {
    return HomeState(
      query: query ?? this.query,
      activeFilter: clearFilter ? null : activeFilter ?? this.activeFilter,
      userName: userName ?? this.userName,
      unreadNotifications: unreadNotifications ?? this.unreadNotifications,
      banners: banners ?? this.banners,
      storiesStatus: storiesStatus ?? this.storiesStatus,
      storeStories: storeStories ?? this.storeStories,
      storiesError: storiesError ?? this.storiesError,
      storesStatus: storesStatus ?? this.storesStatus,
      suggestedStores: suggestedStores ?? this.suggestedStores,
      storesError: storesError ?? this.storesError,
      actionMessage: actionMessage,
    );
  }
}
