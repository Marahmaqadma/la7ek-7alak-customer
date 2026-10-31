import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:la7ek_7alak/core/routing/app_router.dart';

import '../../domain/entities/customer_profile.dart';
import '../cubit/account_settings_cubit/account_settings_cubit.dart';
import '../mock/customer_mock_data.dart';
import '../navigation/customer_tabs.dart';
import '../widgets/home/bottom_nav_bar.dart';
import '../widgets/profile/logout_dialog.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/profile_option_card.dart';

// صفحة "حسابي": الاسم والمدينة والصورة من AccountSettingsCubit (api/me/settings).
// الـ cubit وتسجيل الخروج يأتيان من الـ router (AppRouter.profile).
// عند الربط: رفع الصورة المختارة.
class ProfilePage extends StatelessWidget {
  // ينهي الجلسة (Firebase + الرمز المحفوظ)؛ الصفحة تتولى الانتقال بعده.
  final Future<void> Function() onLogout;

  const ProfilePage({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AccountSettingsCubit>();

    // رسائل رفع الصورة: "جاري الرفع" عند البدء، ثم نتيجة الخادم.
    return BlocConsumer<AccountSettingsCubit, AccountSettingsState>(
      listenWhen: (prev, curr) =>
          curr.actionMessage != null ||
          (!prev.isUploadingAvatar && curr.isUploadingAvatar),
      listener: (context, state) => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(
            state.actionMessage ?? 'جاري رفع الصورة…',
            textAlign: TextAlign.right,
          ),
        )),
      builder: (context, state) => _buildView(context, cubit, state),
    );
  }

  Widget _buildView(
    BuildContext context,
    AccountSettingsCubit cubit,
    AccountSettingsState state,
  ) {
    return ProfileView(
      profile: CustomerProfile(
        // حتى يصل الاسم من الخادم نترك المكان فارغًا بدل اسم وهمي.
        name: state.settings?.fullName ?? '',
        location: state.settings?.cityName ?? '',
        // بدون صورة مرفوعة نعرض الصورة الافتراضية.
        imageUrl: state.settings?.avatarUrl ?? CustomerMockData.profileImage,
      ),
      // اختيار الصورة من المعرض شغل الجهاز فيبقى هنا؛ رفعها مسؤولية الـ cubit.
      // نصغّرها (حتى 1024 بكسل، JPEG بجودة 80) لرفع أسرع على نت ضعيف.
      onEditImageTap: () async {
        final picked = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          maxWidth: 1024,
          maxHeight: 1024,
          imageQuality: 80,
        );
        if (picked == null) return;
        cubit.uploadAvatar(picked.path);
      },
      onInterestsTap: () => Navigator.pushNamed(
        context,
        AppRouter.interests,
        arguments: false,
      ),
      // بعد الرجوع من الإعدادات نعيد التحميل ليظهر الاسم المعدّل.
      onSettingsTap: () async {
        await Navigator.pushNamed(context, AppRouter.accountSettings);
        cubit.load();
      },
      onHelpTap: () => Navigator.pushNamed(context, AppRouter.helpSupport),
      // بعد الخروج نمسح كل الشاشات حتى لا يرجع زر الرجوع للحساب.
      onLogoutConfirmed: () async {
        await onLogout();
        if (!context.mounted) return;
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRouter.login, (_) => false);
      },
      onNavTap: (index) =>
          openCustomerTab(context, index, current: CustomerTab.profile),
    );
  }
}

// واجهة "حسابي" فقط.
class ProfileView extends StatelessWidget {
  final CustomerProfile profile;
  final VoidCallback onEditImageTap;
  final VoidCallback onInterestsTap;
  final VoidCallback onSettingsTap;
  final VoidCallback onHelpTap;
  final VoidCallback onLogoutConfirmed;
  final ValueChanged<int> onNavTap;

  const ProfileView({
    super.key,
    required this.profile,
    required this.onEditImageTap,
    required this.onInterestsTap,
    required this.onSettingsTap,
    required this.onHelpTap,
    required this.onLogoutConfirmed,
    required this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            ProfileHeader(
              name: profile.name,
              location: profile.location,
              imageUrl: profile.imageUrl,
              onEditImageTap: onEditImageTap,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(top: 24.h, bottom: 16.h),
                children: [
                  ProfileOptionCard(
                    title: 'تعديل الاهتمامات والتفضيلات',
                    icon: Icons.edit,
                    onTap: onInterestsTap,
                  ),
                  ProfileOptionCard(
                    title: 'إعدادات الحساب والتنبيهات',
                    icon: Icons.settings,
                    onTap: onSettingsTap,
                  ),
                  ProfileOptionCard(
                    title: 'المساعدة والدعم الفني',
                    icon: Icons.headset_mic_outlined,
                    onTap: onHelpTap,
                  ),
                  ProfileOptionCard(
                    title: 'تسجيل الخروج',
                    icon: Icons.logout,
                    color: const Color(0xFFE10000),
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) =>
                          LogoutDialog(onConfirm: onLogoutConfirmed),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavBarWidget(
          currentIndex: CustomerTab.profile,
          onTap: onNavTap,
        ),
      ),
    );
  }
}
