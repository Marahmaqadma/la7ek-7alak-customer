import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

import 'package:la7ek_7alak/core/routing/app_router.dart';
import '../cubit/interests_cubit/interests_cubit.dart';
import '../widgets/interests/interests_bottom_button.dart';
import '../widgets/interests/interests_card.dart';
import '../widgets/interests/interests_header.dart';

// شاشة اختيار الاهتمامات: تقرأ الحالة من InterestsCubit وتعرضها.
class InterestsPage extends StatelessWidget {
  const InterestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InterestsCubit, InterestsState>(
      listenWhen: (prev, curr) =>
          prev.saveStatus != curr.saveStatus ||
          prev.loadStatus != curr.loadStatus,
      listener: (context, state) {
        final isOnboarding = context.read<InterestsCubit>().isOnboarding;

        if (state.loadStatus == InterestsLoadStatus.alreadyCompleted) {
          Navigator.pushReplacementNamed(context, AppRouter.home);
          return;
        }

        if (state.saveStatus == InterestsSaveStatus.success) {
          if (isOnboarding) {
            Navigator.pushReplacementNamed(context, AppRouter.home);
          } else {
            Navigator.pop(context);
          }
        } else if (state.saveStatus == InterestsSaveStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'تعذر الحفظ')),
          );
        }
      },
      builder: (context, state) {
        switch (state.loadStatus) {
          case InterestsLoadStatus.initial:
          case InterestsLoadStatus.loading:
          case InterestsLoadStatus.alreadyCompleted:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );

          case InterestsLoadStatus.error:
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.errorMessage ?? 'حدث خطأ'),
                    TextButton(
                      onPressed: () =>
                          context.read<InterestsCubit>().loadInterests(),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            );

          case InterestsLoadStatus.loaded:
            final cubit = context.read<InterestsCubit>();
            final selectedCount = state.selectedIds.length;

            // الشاشة عربية: الاتجاه من اليمين لليسار كما في التصميم.
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                backgroundColor: AppColors.white,
                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(16.w, 30.h, 16.w, 24.h),
                    child: Column(
                      children: [
                        InterestsHeaderWidget(
                          selectedCount: selectedCount,
                          totalCount: state.categories.length,
                        ),
                        SizedBox(height: 24.h),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: state.categories.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16.w,
                            mainAxisSpacing: 16.h,
                            childAspectRatio: 152 / 104,
                          ),
                          itemBuilder: (context, index) {
                            final category = state.categories[index];
                            return InterestCard(
                              title: category.name,
                              icon: category.icon,
                              isSelected:
                                  state.selectedIds.contains(category.id),
                              onTap: () => cubit.toggleInterest(category.id),
                            );
                          },
                        ),
                        // الزر تحت الشبكة مباشرة كما في التصميم، وليس مثبتًا أسفل الشاشة.
                        SizedBox(height: 24.h),
                        InterestsBottomButtonWidget(
                          selectedCount: selectedCount,
                          isLoading: state.isSaving,
                          onPressed: cubit.saveInterests,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
        }
      },
    );
  }
}
