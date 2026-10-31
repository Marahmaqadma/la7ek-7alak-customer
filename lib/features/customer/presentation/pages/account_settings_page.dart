import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

import '../../domain/entities/customer_profile.dart';
import '../cubit/account_settings_cubit/account_settings_cubit.dart';
import '../widgets/account_settings/account_settings_form.dart';
import '../widgets/common/customer_page_header.dart';
import '../widgets/common/customer_primary_button.dart';

// صفحة إعدادات الحساب: تقرأ حالة AccountSettingsCubit وتزوّد AccountSettingsView بها.
// الـ cubit يُنشأ في الـ router (AppRouter.accountSettings).
class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AccountSettingsCubit>();

    return BlocConsumer<AccountSettingsCubit, AccountSettingsState>(
      listenWhen: (_, curr) => curr.actionMessage != null,
      listener: (context, state) => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(state.actionMessage!, textAlign: TextAlign.right),
        )),
      // الواجهة تُبنى مرة واحدة عند وصول الإعدادات حتى لا تُمسح تعديلات الزبون.
      buildWhen: (prev, curr) =>
          prev.status != curr.status || prev.isSaving != curr.isSaving,
      builder: (context, state) {
        final settings = state.settings;
        if (settings == null) {
          return _LoadingOrErrorView(
            error: state.status == AccountSettingsStatus.error
                ? state.error
                : null,
            onRetry: cubit.load,
          );
        }
        return AccountSettingsView(
          settings: settings,
          isSaving: state.isSaving,
          onSave: cubit.save,
        );
      },
    );
  }
}

// شاشة التحميل أو الخطأ قبل وصول الإعدادات.
class _LoadingOrErrorView extends StatelessWidget {
  final String? error;
  final VoidCallback onRetry;

  const _LoadingOrErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontFamily: 'Tajawal',
      fontSize: 13.sp,
      color: AppColors.introSubtitleGrey,
    );
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const CustomerPageHeader(title: 'إعدادات الحساب والتنبيهات'),
            Expanded(
              child: Center(
                child: error == null
                    ? const CircularProgressIndicator()
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(error!,
                              textAlign: TextAlign.center, style: style),
                          TextButton(
                            onPressed: onRetry,
                            child: Text(
                              'إعادة المحاولة',
                              style: style.copyWith(color: AppColors.introNavy),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// واجهة الإعدادات: التعديلات مسودة داخل الشاشة (حالة واجهة) حتى الضغط على
// "حفظ التغييرات"، فتُرسل كاملة عبر onSave.
class AccountSettingsView extends StatefulWidget {
  final AccountSettings settings;
  final ValueChanged<AccountSettings> onSave;
  final bool isSaving;

  const AccountSettingsView({
    super.key,
    required this.settings,
    required this.onSave,
    this.isSaving = false,
  });

  @override
  State<AccountSettingsView> createState() => _AccountSettingsViewState();
}

class _AccountSettingsViewState extends State<AccountSettingsView> {
  late final TextEditingController _nameController =
      TextEditingController(text: widget.settings.fullName);
  late final TextEditingController _phoneController =
      TextEditingController(text: widget.settings.phone);
  late bool _newOffers = widget.settings.newOffersNotifications;
  late bool _expiringOffers = widget.settings.expiringOffersNotifications;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _save() {
    widget.onSave(AccountSettings(
      fullName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      // لا تُعدّل في هذه الشاشة.
      avatarUrl: widget.settings.avatarUrl,
      cityName: widget.settings.cityName,
      newOffersNotifications: _newOffers,
      expiringOffersNotifications: _expiringOffers,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const CustomerPageHeader(title: 'إعدادات الحساب والتنبيهات'),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
                children: [
                  AccountSettingsFormSection(
                    nameController: _nameController,
                    phoneController: _phoneController,
                    newOffersNotification: _newOffers,
                    expiringOffersNotification: _expiringOffers,
                    onNewOffersChanged: (v) => setState(() => _newOffers = v),
                    onExpiringOffersChanged: (v) =>
                        setState(() => _expiringOffers = v),
                  ),
                  SizedBox(height: 30.h),
                  CustomerPrimaryButton(
                    label: 'حفظ التغييرات',
                    isLoading: widget.isSaving,
                    onTap: _save,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
