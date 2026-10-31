import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/followed_store.dart';
import '../../../domain/repositories/customer_repository.dart';

part 'followers_state.dart';

// يدير قائمة المتاجر المتابَعة: جلبها، والبحث فيها، وإلغاء متابعتها.
class FollowersCubit extends Cubit<FollowersState> {
  final CustomerRepository customerRepository;

  FollowersCubit(this.customerRepository) : super(const FollowersState());

  Future<void> load() async {
    emit(state.copyWith(status: FollowersStatus.loading));

    final result = await customerRepository.getFollowingStores();

    // الزبون ممكن يغادر الشاشة أثناء الانتظار.
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(
        status: FollowersStatus.error,
        error: failure.message,
      )),
      (stores) => emit(state.copyWith(
        status: FollowersStatus.loaded,
        stores: stores,
      )),
    );
  }

  // البحث محلي بالاسم؛ القائمة كاملة عندنا ولا يوجد endpoint للبحث.
  void search(String query) => emit(state.copyWith(query: query));

  // يشيل المتجر من القائمة فورًا؛ إن فشل الطلب يعيده ويعرض الخطأ.
  Future<void> unfollow(FollowedStore store) async {
    final before = state.stores;
    emit(state.copyWith(
      stores: before.where((s) => s.id != store.id).toList(),
    ));

    final result = await customerRepository.unfollowStore(store.id);
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(
        stores: before,
        actionMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        actionMessage: 'تم إلغاء متابعة ${store.name}',
      )),
    );
  }
}
