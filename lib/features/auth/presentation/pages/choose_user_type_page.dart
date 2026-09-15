import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../cubit/choose_user_type/choose_user_type_cubit.dart';
import '../widgets/login_type_card.dart' show LoginType;
import '../widgets/user_type_option_card.dart';

// يوفّر حالة اختيار نوع المستخدم لشاشة المستهلك والتاجر.
class ChooseUserTypePage extends StatelessWidget {
  const ChooseUserTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChooseUserTypeCubit(),
      child: const _ChooseUserTypeView(),
    );
  }
}

// يرتب خلفية اختيار النوع والعنوان والبطاقات.
class _ChooseUserTypeView extends StatelessWidget {
  const _ChooseUserTypeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            const _ChooseTypeBackground(),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: BlocBuilder<ChooseUserTypeCubit, LoginType>(
                  builder: (context, selectedType) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 28.h),
                        const _ChooseTypeHeader(),
                        SizedBox(height: 28.h),
                        _ChooseTypeOptions(selectedType: selectedType),
                        SizedBox(height: 24.h),
                        CustomButton(
                          text: 'تسجيل الدخول',
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              AppRouter.loginCredentials,
                              arguments: selectedType,
                            );
                          },
                          backgroundColor: AppColors.introNavy,
                          textStyle: AppTextStyles.introButtonText,
                          width: double.infinity,
                          height: 40.h,
                          borderRadius: 10.r,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// دوائر زخرفية خلف محتوى شاشة اختيار نوع المستخدم.
class _ChooseTypeBackground extends StatelessWidget {
  const _ChooseTypeBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(top: -28.h, left: -28.w, child: _circle(76.w)),
        Positioned(top: 58.h, right: -22.w, child: _circle(52.w)),
        Positioned(bottom: 112.h, left: -46.w, child: _circle(104.w)),
        Positioned(bottom: 16.h, right: -18.w, child: _circle(58.w)),
      ],
    );
  }

  // ينشئ الدائرة المستخدمة في زخرفة الخلفية.
  Widget _circle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.decorativePeach,
        shape: BoxShape.circle,
      ),
    );
  }
}

// عنوان وتعليمات تساعد المستخدم على اختيار نوع حسابه.
class _ChooseTypeHeader extends StatelessWidget {
  const _ChooseTypeHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'اختر نوع المستخدم',
          textAlign: TextAlign.center,
          style: AppTextStyles.userTypeTitle,
        ),
        SizedBox(height: 10.h),
        Text(
          'اختر دورك لنقدم لك تجربة مخصصة تناسب احتياجاتك',
          textAlign: TextAlign.center,
          style: AppTextStyles.userTypeSubtitle,
        ),
      ],
    );
  }
}

// بطاقتا المستهلك والتاجر؛ يتغير التحديد عند اختيار إحداهما.
class _ChooseTypeOptions extends StatelessWidget {
  final LoginType selectedType;

  const _ChooseTypeOptions({required this.selectedType});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChooseUserTypeCubit>();

    return Row(
      textDirection: TextDirection.ltr,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserTypeOptionCard(
          title: 'الدخول كمستهلك',
          subtitle: 'تصفح العروض واستمتع بالتوفير',
          imageAsset: 'assets/images/icon_consumer.jpg',
          isSelected: selectedType == LoginType.consumer,
          onTap: () => cubit.selectType(LoginType.consumer),
        ),
        SizedBox(width: 10.w),
        UserTypeOptionCard(
          title: 'الدخول كتاجر',
          subtitle: 'انشر عروض منتجك ووصل لعملائك',
          imageAsset: 'assets/images/icon_merchant.jpg',
          isSelected: selectedType == LoginType.merchant,
          onTap: () => cubit.selectType(LoginType.merchant),
        ),
      ],
    );
  }
}
