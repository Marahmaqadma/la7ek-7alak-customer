import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/store_profile.dart';
import '../../../domain/entities/store_story.dart';
import '../../../domain/repositories/customer_repository.dart';

part 'store_profile_state.dart';

// يدير صفحة متجر واحد: بياناته وقصصه، ومتابعته، ومشاهدة قصصه والإعجاب بها.
class StoreProfileCubit extends Cubit<StoreProfileState> {
  final CustomerRepository customerRepository;
  final String storeId;

  StoreProfileCubit(this.customerRepository, {required this.storeId})
      : super(const StoreProfileState());

  // يجلب البيانات والقصص والإعلانات معًا؛ فشل القصص أو الإعلانات لا يمنع عرض الصفحة.
  Future<void> load() async {
    emit(state.copyWith(status: StoreProfileStatus.loading));

    // الطلبات تبدأ معًا لتقليل الانتظار.
    final profileFuture = customerRepository.getStoreProfile(storeId);
    final storiesFuture = customerRepository.getStoreStories(storeId);
    final adsFuture = customerRepository.getStoreAds(storeId);
    final profileResult = await profileFuture;
    final storiesResult = await storiesFuture;
    final adsResult = await adsFuture;

    // الزبون ممكن يغادر الشاشة أثناء الانتظار.
    if (isClosed) return;

    final stories = storiesResult.fold((_) => <StoryItem>[], (s) => s);
    final ads = adsResult.fold((_) => <StoreAd>[], (a) => a);

    profileResult.fold(
      (failure) => emit(state.copyWith(
        status: StoreProfileStatus.error,
        error: failure.message,
      )),
      (profile) => emit(state.copyWith(
        status: StoreProfileStatus.loaded,
        // للمتجر قصص إن وصلت قصص، حتى لو لم يرجع الخادم hasActiveStory.
        profile: profile.copyWithActiveStory(
          profile.hasActiveStory || stories.isNotEmpty,
        ),
        stories: stories,
        ads: ads,
      )),
    );
  }

  // يقلب المتابعة فورًا (الزر وعدد المتابعين)؛ إن فشل الطلب يعيدها ويعرض الخطأ.
  Future<void> toggleFollow() async {
    final before = state.profile;
    if (before == null) return;
    final follow = !before.isFollowing;

    emit(state.copyWith(profile: before.copyWithFollowing(follow)));

    final result = follow
        ? await customerRepository.followStore(storeId)
        : await customerRepository.unfollowStore(storeId);
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(
        profile: before,
        actionMessage: failure.message,
      )),
      // نعتمد ما أكده الخادم (قد يختلف العدد إن تابع آخرون بنفس الوقت).
      (status) => emit(state.copyWith(
        profile: before.copyWithFollowing(
          status.isFollowing,
          followersCount: status.followersCount,
        ),
      )),
    );
  }

  // يبلّغ عن المتجر كاملًا (stores/:id/reports)، بإعلانات أو بدونها.
  Future<void> reportStore(String reason) async {
    final result = await customerRepository.reportStore(storeId, reason);
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(actionMessage: failure.message)),
      (_) => emit(state.copyWith(
        actionMessage: 'تم إرسال البلاغ، شكرًا لك',
      )),
    );
  }

  // يعلّم القصة مشاهدة ويسجلها في الخادم مرة واحدة؛ الفشل لا يزعج الزبون.
  Future<void> markStoryViewed(String storyId) async {
    final already = state.stories.any((s) => s.id == storyId && s.isViewed);
    if (already) return;

    emit(state.copyWith(
      stories:
          state.stories.updateItem(storyId, (s) => s.copyWith(isViewed: true)),
    ));
    await customerRepository.viewStory(storyId);
  }

  // يقلب الإعجاب فورًا؛ إن فشل الطلب يعيده ويعرض الخطأ.
  Future<void> toggleStoryLike(String storyId) async {
    final before = state.stories;
    final target = before.where((s) => s.id == storyId).firstOrNull;
    if (target == null) return;
    final liked = !target.isLiked;

    emit(state.copyWith(
      stories: before.updateItem(storyId, (s) => s.copyWith(isLiked: liked)),
    ));

    final result = await customerRepository.setStoryLiked(storyId, liked);
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(
        stories: before,
        actionMessage: failure.message,
      )),
      (_) {},
    );
  }
}
