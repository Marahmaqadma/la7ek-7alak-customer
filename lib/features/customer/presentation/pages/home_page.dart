import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/routing/app_router.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

import '../../domain/entities/home_banner.dart';
import '../../domain/entities/store_story.dart';
import '../../domain/entities/story_preview.dart';
import '../../domain/entities/suggested_store.dart';
import '../cubit/home_cubit/home_cubit.dart';
import '../navigation/customer_tabs.dart';
import '../widgets/home/bottom_nav_bar.dart';
import '../widgets/home/home_banner.dart';
import '../widgets/home/home_header.dart';
import '../widgets/home/live_stories.dart';
import '../widgets/home/suggested_stores.dart';
import 'story_page.dart';

// صفحة الرئيسية: تقرأ حالة HomeCubit وتزوّد HomeView بها، وتحدد ماذا يحدث عند كل تفاعل.
// كل بيانات الرئيسية من الخادم (البانرات، القصص، المتاجر المقترحة، الاسم).
// الـ HomeCubit يُنشأ في الـ router (AppRouter.home).
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();

    return BlocConsumer<HomeCubit, HomeState>(
      listenWhen: (_, curr) => curr.actionMessage != null,
      listener: (context, state) => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(state.actionMessage!, textAlign: TextAlign.right),
        )),
      builder: (context, state) => HomeView(
        userName: state.userName,
        banners: state.banners,
        onBannerTap: (banner) {
          if (banner.storeId == null) return;
          Navigator.pushNamed(
            context,
            AppRouter.storeProfile,
            arguments: banner.storeId,
          );
        },
        stories: state.visibleStories.map((s) => s.toPreview()).toList(),
        isStoriesLoading: state.storiesStatus == SectionStatus.loading,
        storiesError: state.storiesStatus == SectionStatus.error
            ? state.storiesError
            : null,
        onRetryStories: cubit.loadStories,
        suggestedStores: state.visibleStores,
        isSuggestedStoresLoading: state.storesStatus == SectionStatus.loading,
        suggestedStoresError: state.storesStatus == SectionStatus.error
            ? state.storesError
            : null,
        onRetrySuggestedStores: cubit.loadSuggestedStores,
        onSearchChanged: cubit.search,
        isSearching: state.isSearching,
        onStoryTap: (preview) {
          if (cubit.storyOf(preview.storeId) == null) return;
          // شاشة القصة تقرأ نفس الـ cubit حتى يتحدث القلب فورًا عند الإعجاب.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: cubit,
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, _) {
                    final story = cubit.storyOf(preview.storeId);
                    if (story == null) return const SizedBox.shrink();
                    return StoryScreen(
                      story: story,
                      onItemShown: (item) => cubit.markStoryViewed(item.id),
                      onLikeTap: (item) => cubit.toggleStoryLike(item.id),
                    );
                  },
                ),
              ),
            ),
          );
        },
        onSelectFilter: cubit.selectFilter,
        activeFilter: state.activeFilter,
        onRefresh: cubit.refresh,
        onMapTap: () => Navigator.pushNamed(context, AppRouter.storesMap),
        onFollowStore: cubit.followStore,
        onDismissStore: cubit.dismissStore,
        onStoreTap: (store) => Navigator.pushNamed(
          context,
          AppRouter.storeProfile,
          arguments: store.id,
        ),
        hasUnreadNotifications: state.unreadNotifications > 0,
        // بعد الرجوع للرئيسية نحدّث نقطة الإشعارات (ربما قُرئت).
        onNavTap: (index) async {
          await openCustomerTab(context, index, current: CustomerTab.home);
          cubit.loadUnreadCount();
        },
      ),
    );
  }
}

// واجهة الرئيسية فقط: تعرض ما يصلها وتبلّغ عن التفاعلات، ولا تعرف شيئًا عن الـ API.
class HomeView extends StatelessWidget {
  final String userName;
  final List<HomeBanner> banners;
  final ValueChanged<HomeBanner>? onBannerTap;
  final List<StoryPreview> stories;
  final bool isStoriesLoading;
  // أثناء البحث تظهر "لا توجد نتائج" بدل رسالة عدم وجود قصص.
  final bool isSearching;
  final String? storiesError;
  final VoidCallback? onRetryStories;
  final List<SuggestedStore> suggestedStores;
  final bool isSuggestedStoresLoading;
  final String? suggestedStoresError;
  final VoidCallback? onRetrySuggestedStores;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<StoryPreview> onStoryTap;
  final ValueChanged<String> onSelectFilter;
  // الفلتر المفعّل ليظهر اسمه على زر التصفية.
  final String? activeFilter;
  // السحب للأسفل لإعادة تحميل الرئيسية.
  final Future<void> Function()? onRefresh;
  final VoidCallback onMapTap;
  final ValueChanged<SuggestedStore> onFollowStore;
  final ValueChanged<SuggestedStore> onDismissStore;
  final ValueChanged<SuggestedStore>? onStoreTap;
  final ValueChanged<int> onNavTap;
  final bool hasUnreadNotifications;

  const HomeView({
    super.key,
    required this.userName,
    required this.banners,
    this.onBannerTap,
    required this.stories,
    this.isStoriesLoading = false,
    this.isSearching = false,
    this.storiesError,
    this.onRetryStories,
    required this.suggestedStores,
    this.isSuggestedStoresLoading = false,
    this.suggestedStoresError,
    this.onRetrySuggestedStores,
    required this.onSearchChanged,
    required this.onStoryTap,
    required this.onSelectFilter,
    this.activeFilter,
    this.onRefresh,
    required this.onMapTap,
    required this.onFollowStore,
    required this.onDismissStore,
    this.onStoreTap,
    required this.onNavTap,
    this.hasUnreadNotifications = false,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: onRefresh ?? () async {},
          color: AppColors.orangeF58B1F,
          child: SingleChildScrollView(
            // AlwaysScrollable حتى يعمل السحب حتى لو المحتوى أقصر من الشاشة.
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeHeaderWidget(
                  userName: userName,
                  onSearchChanged: onSearchChanged,
                ),
                SizedBox(height: 16.h),
                HomeBannerWidget(banners: banners, onBannerTap: onBannerTap),
                SizedBox(height: 20.h),
                StoriesSectionWidget(
                  stories: stories,
                  isLoading: isStoriesLoading,
                  emptyText: isSearching ? 'لا توجد نتائج' : null,
                  errorMessage: storiesError,
                  onRetry: onRetryStories,
                  onStoryTap: onStoryTap,
                  onSelectFilter: onSelectFilter,
                  activeFilter: activeFilter,
                  onMapTap: onMapTap,
                ),
                SizedBox(height: 20.h),
                SuggestedStoresWidget(
                  stores: suggestedStores,
                  isLoading: isSuggestedStoresLoading,
                  errorMessage: suggestedStoresError,
                  onRetry: onRetrySuggestedStores,
                  onFollowTap: onFollowStore,
                  onDismissTap: onDismissStore,
                  onStoreTap: onStoreTap,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBarWidget(
          currentIndex: CustomerTab.home,
          onTap: onNavTap,
          hasUnreadNotifications: hasUnreadNotifications,
        ),
      ),
    );
  }
}
