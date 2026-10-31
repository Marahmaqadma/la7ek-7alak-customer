import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/routing/app_router.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';
import 'package:la7ek_7alak/core/utils/helpers.dart';

import '../../domain/entities/followed_store.dart';
import '../cubit/followers_cubit/followers_cubit.dart';
import '../navigation/customer_tabs.dart';
import '../widgets/common/customer_page_header.dart';
import '../widgets/followers/follower_card.dart';
import '../widgets/followers/followers_search_bar.dart';
import '../widgets/home/bottom_nav_bar.dart';

// صفحة المتاجر المتابَعة: تقرأ حالة FollowersCubit وتزوّد FollowersView بها.
// الـ cubit يُنشأ في الـ router (AppRouter.followers).
class FollowersPage extends StatelessWidget {
  const FollowersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FollowersCubit>();

    return BlocConsumer<FollowersCubit, FollowersState>(
      listenWhen: (_, curr) => curr.actionMessage != null,
      listener: (context, state) => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(state.actionMessage!, textAlign: TextAlign.right),
        )),
      builder: (context, state) => FollowersView(
        stores: state.visibleStores,
        isLoading: state.status == FollowersStatus.loading,
        errorMessage:
            state.status == FollowersStatus.error ? state.error : null,
        onRetry: cubit.load,
        isSearching: state.query.trim().isNotEmpty,
        onSearchChanged: cubit.search,
        onStoreTap: (store) => Navigator.pushNamed(
          context,
          AppRouter.storeProfile,
          arguments: store.id,
        ),
        onUnfollowTap: cubit.unfollow,
        onNavTap: (index) =>
            openCustomerTab(context, index, current: CustomerTab.followers),
      ),
    );
  }
}

// واجهة المتاجر المتابَعة فقط.
class FollowersView extends StatelessWidget {
  final List<FollowedStore> stores;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  // للتمييز بين "لا نتائج للبحث" و"لا تتابع أي متجر".
  final bool isSearching;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<FollowedStore> onStoreTap;
  final ValueChanged<FollowedStore> onUnfollowTap;
  final ValueChanged<int> onNavTap;

  const FollowersView({
    super.key,
    required this.stores,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
    this.isSearching = false,
    required this.onSearchChanged,
    required this.onStoreTap,
    required this.onUnfollowTap,
    required this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            const CustomerPageHeader(title: 'المتابعين'),
            SizedBox(height: 16.h),
            FollowersSearchBar(onSearchChanged: onSearchChanged),
            SizedBox(height: 10.h),
            // السحب للأسفل يعيد تحميل القائمة.
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => onRetry?.call(),
                color: AppColors.orangeF58B1F,
                child: _buildContent(),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavBarWidget(
          currentIndex: CustomerTab.followers,
          onTap: onNavTap,
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(errorMessage!,
                textAlign: TextAlign.center, style: _messageStyle),
            if (onRetry != null)
              TextButton(
                onPressed: onRetry,
                child: Text(
                  'إعادة المحاولة',
                  style: _messageStyle.copyWith(color: AppColors.introNavy),
                ),
              ),
          ],
        ),
      );
    }
    if (stores.isEmpty) {
      return Center(
        child: Text(
          isSearching ? 'لا توجد نتائج' : 'لا توجد متاجر متابَعة',
          style: _messageStyle,
        ),
      );
    }
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(bottom: 15.h),
      itemCount: stores.length,
      itemBuilder: (context, index) {
        final store = stores[index];
        return FollowerCard(
          storeName: store.name,
          subtitle: store.subtitle,
          // وقت آخر عرض إن وُجد، وإلا منذ متى يتابعه.
          timeAgo: store.latestOfferAt != null
              ? timeAgoArabic(store.latestOfferAt!)
              : store.followedAt != null
                  ? 'تتابعه ${timeAgoArabic(store.followedAt!)}'
                  : '',
          imageUrl: store.imageUrl,
          categoryIcon: store.categoryIcon,
          onStoreTap: () => onStoreTap(store),
          onUnfollowTap: () => onUnfollowTap(store),
        );
      },
    );
  }

  TextStyle get _messageStyle => TextStyle(
        fontFamily: 'Tajawal',
        color: AppColors.grey,
        fontSize: 14.sp,
      );
}
