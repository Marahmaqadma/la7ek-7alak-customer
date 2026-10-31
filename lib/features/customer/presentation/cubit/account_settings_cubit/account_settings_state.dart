part of 'account_settings_cubit.dart';

enum AccountSettingsStatus { initial, loading, loaded, error }

class AccountSettingsState {
  final AccountSettingsStatus status;
  final AccountSettings? settings;
  final bool isSaving;
  // أثناء رفع صورة الزبون (يظهر مؤشر على الصورة).
  final bool isUploadingAvatar;
  final String? error;
  // رسالة لمرة واحدة (نجح الحفظ / فشل) تعرضها الواجهة كـ SnackBar.
  final String? actionMessage;

  const AccountSettingsState({
    this.status = AccountSettingsStatus.initial,
    this.settings,
    this.isSaving = false,
    this.isUploadingAvatar = false,
    this.error,
    this.actionMessage,
  });

  AccountSettingsState copyWith({
    AccountSettingsStatus? status,
    AccountSettings? settings,
    bool? isSaving,
    bool? isUploadingAvatar,
    String? error,
    String? actionMessage,
  }) {
    return AccountSettingsState(
      status: status ?? this.status,
      settings: settings ?? this.settings,
      isSaving: isSaving ?? this.isSaving,
      isUploadingAvatar: isUploadingAvatar ?? this.isUploadingAvatar,
      error: error ?? this.error,
      actionMessage: actionMessage,
    );
  }
}
