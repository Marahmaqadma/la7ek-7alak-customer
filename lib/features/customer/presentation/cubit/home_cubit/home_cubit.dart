import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la7ek_7alak/core/utils/helpers.dart';

import '../../../domain/entities/home_banner.dart';
import '../../../domain/entities/store_story.dart';
import '../../../domain/entities/suggested_store.dart';
import '../../../domain/repositories/customer_repository.dart';

part 'home_state.dart';

// يدير بيانات رئيسية الزبون ويحوّلها لحالات تعرضها الواجهة.
class HomeCubit extends Cubit<HomeState> {
  final CustomerRepository customerRepository;

  HomeCubit(this.customerRepository) : super(const HomeState());

  // يحمّل أقسام الرئيسية معًا؛ كل قسم يظهر حالما يصل بشكل مستقل.
  Future<void> loadAll() async {
    await Future.wait([
      loadStories(),
      loadSuggestedStores(),
      loadBanners(),
      loadUnreadCount(),
      loadUserName(),
    ]);
  }

  // بانرات الإعلانات النشطة؛ الفشل أو عدم وجود بانرات يخفي القسم فقط.
  Future<void> loadBanners() async {
    final result = await customerRepository.getBanners();
    if (isClosed) return;
    result.fold(
      (_) {},
      (banners) => emit(state.copyWith(banners: banners)),
    );
  }

  // اسم الزبون من الإعدادات؛ الفشل يترك الهيدر بدون اسم.
  Future<void> loadUserName() async {
    final result = await customerRepository.getAccountSettings();
    if (isClosed) return;
    result.fold(
      (_) {},
      (settings) => emit(state.copyWith(userName: settings.fullName)),
    );
  }

  // عدد الإشعارات غير المقروءة؛ الفشل يخفي النقطة فقط.
  Future<void> loadUnreadCount() async {
    final result = await customerRepository.getUnreadNotificationsCount();
    if (isClosed) return;
    emit(state.copyWith(
      unreadNotifications: result.fold((_) => 0, (count) => count),
    ));
  }

  // يجلب القصص النشطة مجمّعة حسب المتجر.
  // القاعدة: قبل متابعة أي متجر تظهر كل القصص (المطابقة للاهتمامات أولًا)؛
  // بعد أول متابعة تظهر قصص المتاجر المتابَعة فقط.
  // الخادم يطبق القاعدة: stories/following للمتابِع، stories/recommended لغيره.
  Future<void> loadStories() async {
    emit(state.copyWith(storiesStatus: SectionStatus.loading));

    // الطلبان يبدآن معًا لتقليل الانتظار.
    final followingStoresFuture = customerRepository.getFollowingStores();
    final followingStoriesFuture = customerRepository.getFollowingStories();
    final followingStoresResult = await followingStoresFuture;
    var storiesResult = await followingStoriesFuture;

    // الزبون ممكن يغادر الشاشة أثناء الانتظار.
    if (isClosed) return;

    // فشل جلب المتابَعين لا يخفي القصص: نعامله كأنه لا يتابع أحدًا.
    final followsAny = followingStoresResult.fold(
      (_) => false,
      (stores) => stores.isNotEmpty,
    );

    if (!followsAny) {
      storiesResult = await customerRepository.getRecommendedStories();
      if (isClosed) return;
    }

    storiesResult.fold(
      (failure) => emit(state.copyWith(
        storiesStatus: SectionStatus.error,
        storiesError: failure.message,
      )),
      (stories) => emit(state.copyWith(
        storiesStatus: SectionStatus.loaded,
        storeStories: stories,
      )),
    );
  }

  // يجلب المتاجر المقترحة (المطابقة لاهتمامات الزبون أولًا).
  Future<void> loadSuggestedStores() async {
    emit(state.copyWith(storesStatus: SectionStatus.loading));

    final result = await customerRepository.getRecommendedStores();

    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(
        storesStatus: SectionStatus.error,
        storesError: failure.message,
      )),
      (stores) => emit(state.copyWith(
        storesStatus: SectionStatus.loaded,
        suggestedStores: stores,
      )),
    );
  }

  // قصص المتجر الكاملة لفتحها من شريط القصص.
  StoreStory? storyOf(String storeId) {
    for (final story in state.storeStories) {
      if (story.storeId == storeId) return story;
    }
    return null;
  }

  // يعلّم القصة مشاهدة فورًا (فتصير حلقة المتجر رمادية إن شوهدت كل قصصه)،
  // ثم يسجّل المشاهدة في الخادم. فشل التسجيل لا يزعج الزبون، فلا نعرض خطأ.
  Future<void> markStoryViewed(String storyId) async {
    var changed = false;
    final updated = state.storeStories.map((store) {
      if (!store.items.any((i) => i.id == storyId && !i.isViewed)) {
        return store;
      }
      changed = true;
      return store.copyWithItems([
        for (final item in store.items)
          item.id == storyId ? item.copyWith(isViewed: true) : item,
      ]);
    }).toList();

    // شوهدت سابقًا: لا داعي لطلب جديد.
    if (!changed) return;
    emit(state.copyWith(storeStories: updated));

    await customerRepository.viewStory(storyId);
  }

  // يقلب الإعجاب فورًا (القلب يتلوّن مباشرة)؛ إن فشل الطلب يعيده ويعرض الخطأ.
  Future<void> toggleStoryLike(String storyId) async {
    final before = state.storeStories;
    StoryItem? target;
    for (final store in before) {
      for (final item in store.items) {
        if (item.id == storyId) target = item;
      }
    }
    if (target == null) return;
    final liked = !target.isLiked;

    emit(state.copyWith(
      storeStories: [
        for (final store in before)
          store.copyWithItems([
            for (final item in store.items)
              item.id == storyId ? item.copyWith(isLiked: liked) : item,
          ]),
      ],
    ));

    final result = await customerRepository.setStoryLiked(storyId, liked);
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(
        storeStories: before,
        actionMessage: failure.message,
      )),
      (_) {},
    );
  }

  // يتابع المتجر ويخفيه من المقترحات فورًا؛ إن فشل الطلب يعيده لمكانه ويعرض الخطأ.
  Future<void> followStore(SuggestedStore store) async {
    final before = state.suggestedStores;
    emit(state.copyWith(
      suggestedStores: before.where((s) => s.id != store.id).toList(),
    ));

    final result = await customerRepository.followStore(store.id);
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(
        suggestedStores: before,
        actionMessage: failure.message,
      )),
      (_) {
        emit(state.copyWith(actionMessage: 'تمت متابعة ${store.name}'));
        // المتابعة تغيّر قاعدة القصص (المتابَعة فقط)، فنحدّثها فورًا.
        loadStories();
      },
    );
  }

  // البحث محلي باسم المتجر على القصص والمتاجر المحمّلة؛ لا يوجد endpoint للبحث.
  void search(String query) => emit(state.copyWith(query: query));

  // فلتر الرئيسية من شيت التصفية. اختيار الفلتر المفعّل مرة ثانية يلغيه.
  // 'nearest' يفتح الخريطة من الواجهة فلا يصل هنا.
  void selectFilter(String filter) {
    if (filter == 'top_rated') {
      // لا توجد تقييمات في الخادم بعد.
      emit(state.copyWith(
        actionMessage: 'ترتيب الأعلى تقييمًا سيتوفر قريبًا',
      ));
      return;
    }
    if (state.activeFilter == filter) {
      emit(state.copyWith(clearFilter: true));
    } else {
      emit(state.copyWith(activeFilter: filter));
    }
  }

  // السحب للأسفل في الرئيسية: يعيد تحميل كل الأقسام.
  Future<void> refresh() => loadAll();

  // يخفي المتجر من المقترحات في هذه الجلسة فقط (لا يوجد endpoint للإخفاء).
  void dismissStore(SuggestedStore store) {
    emit(state.copyWith(
      suggestedStores:
          state.suggestedStores.where((s) => s.id != store.id).toList(),
    ));
  }
}
