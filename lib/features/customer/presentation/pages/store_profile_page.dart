import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

import '../../domain/entities/store_profile.dart';
import '../cubit/store_profile_cubit/store_profile_cubit.dart';
import '../navigation/customer_tabs.dart';
import '../widgets/home/bottom_nav_bar.dart';
import '../widgets/store_profile/report_dialog.dart';
import '../widgets/store_profile/store_bio.dart';
import '../widgets/store_profile/store_content.dart';
import '../widgets/store_profile/store_header.dart';
import '../widgets/store_profile/store_stats.dart';
import '../widgets/store_profile/store_tabs.dart';
import 'story_page.dart';

// صفحة المتجر: تقرأ حالة StoreProfileCubit وتزوّد StoreProfileView بها.
// الـ cubit يُنشأ في الـ router (AppRouter.storeProfile) مع رقم المتجر.
class StoreProfilePage extends StatelessWidget {
  const StoreProfilePage({super.key});

  // يفتح قصص المتجر بتأثير تكبير؛ [startAt] قصة محددة (من شبكة العروض).
  void _openStories(
    BuildContext context,
    StoreProfileCubit cubit, {
    String? startAt,
    Alignment from = Alignment.topRight,
  }) {
    if (cubit.state.storeStory == null) return;
    Navigator.push(
      context,
      PageRouteBuilder(
        // شاشة القصة تقرأ نفس الـ cubit حتى يتحدث القلب فورًا عند الإعجاب.
        pageBuilder: (_, __, ___) => BlocProvider.value(
          value: cubit,
          child: BlocBuilder<StoreProfileCubit, StoreProfileState>(
            builder: (context, state) {
              final story = state.storeStory;
              if (story == null) return const SizedBox.shrink();
              return StoryScreen(
                story: story,
                initialItemId: startAt,
                onStoreTap: () => Navigator.pop(context),
                onItemShown: (item) => cubit.markStoryViewed(item.id),
                onLikeTap: (item) => cubit.toggleStoryLike(item.id),
              );
            },
          ),
        ),
        transitionsBuilder: (_, animation, __, child) {
          final curve =
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return ScaleTransition(
            scale: Tween<double>(begin: 0.0, end: 1.0).animate(curve),
            alignment: from,
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StoreProfileCubit>();

    return BlocConsumer<StoreProfileCubit, StoreProfileState>(
      listenWhen: (_, curr) => curr.actionMessage != null,
      listener: (context, state) => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(state.actionMessage!, textAlign: TextAlign.right),
        )),
      builder: (context, state) {
        final profile = state.profile;
        if (profile == null) {
          return _LoadingOrErrorView(
            error:
                state.status == StoreProfileStatus.error ? state.error : null,
            onRetry: cubit.load,
          );
        }
        return StoreProfileView(
          store: profile,
          offers: [
            for (final story in state.stories)
              StoreOffer(
                id: story.id,
                imageUrl: story.imageUrl,
                viewsCount: story.viewsCount,
              ),
          ],
          ads: state.ads,
          onStoryPressed: () => _openStories(context, cubit),
          onOfferTap: (offer) => _openStories(
            context,
            cubit,
            startAt: offer.id,
            from: Alignment.center,
          ),
          onFollowPressed: cubit.toggleFollow,
          // زر الإبلاغ ظاهر دائمًا؛ الـ cubit يقرر كيف يرسل البلاغ.
          onReportSubmit: cubit.reportStore,
          // صفحة المتجر ليست تبويبًا، فأي ضغطة (حتى الرئيسية) تفتح التبويب المطلوب.
          onNavTap: (index) => openCustomerTab(context, index),
        );
      },
    );
  }
}

// شاشة التحميل أو الخطأ قبل وصول بيانات المتجر.
class _LoadingOrErrorView extends StatelessWidget {
  final String? error;
  final VoidCallback onRetry;

  const _LoadingOrErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: AppColors.introNavy,
        ),
        body: Center(
          child: error == null
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      error!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 13.sp,
                        color: AppColors.introSubtitleGrey,
                      ),
                    ),
                    TextButton(
                      onPressed: onRetry,
                      child: Text(
                        'إعادة المحاولة',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 13.sp,
                          color: AppColors.introNavy,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// واجهة صفحة المتجر فقط: تعرض ما يصلها وتبلّغ عن التفاعلات.
class StoreProfileView extends StatelessWidget {
  final StoreProfile store;
  final List<StoreOffer> offers;
  final List<StoreAd> ads;
  final VoidCallback onStoryPressed;
  final ValueChanged<StoreOffer> onOfferTap;
  final VoidCallback onFollowPressed;
  // null: لا يوجد ما يُبلَّغ عنه، فيختفي زر الإبلاغ.
  final ValueChanged<String>? onReportSubmit;
  final ValueChanged<int> onNavTap;

  const StoreProfileView({
    super.key,
    required this.store,
    required this.offers,
    required this.ads,
    required this.onStoryPressed,
    required this.onOfferTap,
    required this.onFollowPressed,
    this.onReportSubmit,
    required this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StoreHeaderWidget(
                  name: store.name,
                  imageUrl: store.imageUrl,
                  categoryIcon: store.categoryIcon,
                  location: store.location,
                  isFollowing: store.isFollowing,
                  hasActiveStory: store.hasActiveStory,
                  onBackPressed: () => Navigator.maybePop(context),
                  onStoryPressed: onStoryPressed,
                  onFollowPressed: onFollowPressed,
                  onReportPressed: onReportSubmit == null
                      ? null
                      : () => showDialog(
                            context: context,
                            builder: (_) =>
                                ReportDialogWidget(onSubmit: onReportSubmit!),
                          ),
                ),
                SizedBox(height: 4.h),
                StoreStatsWidget(
                  viewsCount: store.viewsCount,
                  followersCount: store.followersCount,
                ),
                SizedBox(height: 16.h),
                StoreBioWidget(bio: store.bio, phone: store.phone),
                SizedBox(height: 24.h),
                _StoreTabsSection(
                  offers: offers,
                  ads: ads,
                  onOfferTap: onOfferTap,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBarWidget(
          currentIndex: CustomerTab.home,
          onTap: onNavTap,
        ),
      ),
    );
  }
}

// التبويب المختار حالة واجهة فقط، لذا يُحفظ هنا بدل الصفحة.
class _StoreTabsSection extends StatefulWidget {
  final List<StoreOffer> offers;
  final List<StoreAd> ads;
  final ValueChanged<StoreOffer> onOfferTap;

  const _StoreTabsSection({
    required this.offers,
    required this.ads,
    required this.onOfferTap,
  });

  @override
  State<_StoreTabsSection> createState() => _StoreTabsSectionState();
}

class _StoreTabsSectionState extends State<_StoreTabsSection> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StoreTabsWidget(
          selectedTab: _selectedTab,
          onTabChanged: (index) => setState(() => _selectedTab = index),
        ),
        SizedBox(height: 16.h),
        StoreContentWidget(
          selectedTab: _selectedTab,
          offers: widget.offers,
          ads: widget.ads,
          onOfferTap: widget.onOfferTap,
        ),
      ],
    );
  }
}
