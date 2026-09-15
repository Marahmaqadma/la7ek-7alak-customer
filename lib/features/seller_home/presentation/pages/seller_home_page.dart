import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../cubit/seller_home_cubit.dart';
import '../widgets/seller_add_offer_view.dart';
import '../widgets/seller_bottom_nav.dart';
import '../widgets/seller_home_view.dart';
import '../widgets/seller_placeholder_view.dart';

// ينشئ مدير حالة التاجر ويوفره لمكونات الشاشة.
class SellerHomePage extends StatelessWidget {
  const SellerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SellerHomeCubit(),
      child: const _SellerHomeView(),
    );
  }
}

// يربط واجهة التاجر بحالتها ويعرض شريط التنقل.
class _SellerHomeView extends StatelessWidget {
  const _SellerHomeView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SellerHomeCubit, SellerHomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.pageBackground,
          body: SafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Center(
                child: SizedBox(
                  width: 375.w,
                  child: Column(
                    children: [
                      Expanded(child: _SellerBody(state: state)),
                      SellerBottomNav(
                        currentIndex: state.selectedTabIndex,
                        onTap: context.read<SellerHomeCubit>().changeTab,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// يعرض محتوى التبويب المحدد من واجهة التاجر.
class _SellerBody extends StatelessWidget {
  final SellerHomeState state;

  const _SellerBody({required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(18.w, 28.h, 18.w, 16.h),
      child: _buildTab(context),
    );
  }

  // يختار واجهة التبويب ويربط أزرارها بإجراءات مدير الحالة.
  Widget _buildTab(BuildContext context) {
    switch (state.selectedTabIndex) {
      case 1:
        return SellerAddOfferView(
          imagePath: state.draftOfferImagePath,
          onBack: () => context.read<SellerHomeCubit>().changeTab(0),
          onPickImage: (source) {
            context.read<SellerHomeCubit>().pickDraftOfferImage(source);
          },
          onPublish: ({required String title, String? details}) {
            context.read<SellerHomeCubit>().publishOffer(
                  title: title,
                  details: details,
                );
          },
        );
      case 2:
        return const SellerPlaceholderView(title: 'التقارير');
      case 3:
        return const SellerPlaceholderView(title: 'البروفايل');
      default:
        return SellerHomeView(
          state: state,
          onAddOffer: () => context.read<SellerHomeCubit>().changeTab(1),
        );
    }
  }
}
