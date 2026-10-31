part of 'followers_cubit.dart';

enum FollowersStatus { initial, loading, loaded, error }

class FollowersState {
  final FollowersStatus status;
  final List<FollowedStore> stores;
  final String query;
  final String? error;
  // رسالة لمرة واحدة (فشل إلغاء المتابعة مثلًا) تعرضها الواجهة كـ SnackBar.
  final String? actionMessage;

  const FollowersState({
    this.status = FollowersStatus.initial,
    this.stores = const [],
    this.query = '',
    this.error,
    this.actionMessage,
  });

  // المتاجر بعد البحث بالاسم.
  List<FollowedStore> get visibleStores {
    final q = query.trim();
    if (q.isEmpty) return stores;
    return stores.where((s) => s.name.contains(q)).toList();
  }

  FollowersState copyWith({
    FollowersStatus? status,
    List<FollowedStore>? stores,
    String? query,
    String? error,
    String? actionMessage,
  }) {
    return FollowersState(
      status: status ?? this.status,
      stores: stores ?? this.stores,
      query: query ?? this.query,
      error: error ?? this.error,
      actionMessage: actionMessage,
    );
  }
}
