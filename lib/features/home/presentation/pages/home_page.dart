import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/home_cubit.dart';
import '../widgets/home_bottom_nav.dart';
import '../widgets/home_header.dart';
import '../widgets/user_account_page.dart';

// ينشئ مدير حالة المستهلك ويحمّل بياناته المحفوظة عند فتح الشاشة.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(

      // بدء قراءة بيانات الملف الشخصي فور إنشاء مدير الحالة.
      create: (_) => HomeCubit(const StorageService())..loadUserProfile(),
      child: const _HomeView(),
    );
  }
}

// يعيد بناء واجهة المستهلك عند تغير الحالة ويثبت شريط التنقل أسفلها.
class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
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
                      Expanded(child: _HomeBody(state: state)),
                      HomeBottomNav(
                        currentIndex: state.selectedTabIndex,
                        onTap: context.read<HomeCubit>().changeTab,
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

// يعرض صفحة الحساب في تبويبها، أو ترويسة الرئيسية في التبويبات الأخرى.
class _HomeBody extends StatelessWidget {
  final HomeState state;

  const _HomeBody({required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 16.h),
      // تبويب الحساب يعرض بيانات المستخدم؛ بقية التبويبات تعرض الترويسة حاليًا.
      child: state.selectedTabIndex == 2
          ? UserAccountPage(
              state: state,
              onPickProfileImage: context.read<HomeCubit>().pickProfileImage,
              onLogout: () => _logout(context),
            )
          : HomeHeader(city: state.city),
    );
  }

  // يحذف رمز الدخول المحلي ويفتح شاشة اختيار نوع الحساب.
  void _logout(BuildContext context) {
    const StorageService().deleteToken();
    Navigator.pushReplacementNamed(context, AppRouter.login);
  }
}
