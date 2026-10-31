import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/customer_profile.dart';
import '../../../domain/repositories/customer_repository.dart';

part 'account_settings_state.dart';

// يدير بيانات الزبون وإعداداته: جلبها (لشاشة حسابي والإعدادات) وحفظها.
class AccountSettingsCubit extends Cubit<AccountSettingsState> {
  final CustomerRepository customerRepository;

  AccountSettingsCubit(this.customerRepository)
      : super(const AccountSettingsState());

  Future<void> load() async {
    emit(state.copyWith(status: AccountSettingsStatus.loading));

    final result = await customerRepository.getAccountSettings();

    // الزبون ممكن يغادر الشاشة أثناء الانتظار.
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(
        status: AccountSettingsStatus.error,
        error: failure.message,
      )),
      (settings) => emit(state.copyWith(
        status: AccountSettingsStatus.loaded,
        settings: settings,
      )),
    );
  }

  // يرفع الصورة المختارة من المعرض. بعد النجاح نعيد تحميل الإعدادات حتى
  // يصل رابط الصورة الجديد (avatarUrl) من الخادم ويظهر في كل مكان.
  Future<void> uploadAvatar(String filePath) async {
    if (state.isUploadingAvatar) return;
    emit(state.copyWith(isUploadingAvatar: true));

    final result = await customerRepository.uploadAvatar(filePath);
    if (isClosed) return;

    await result.fold(
      (failure) async => emit(state.copyWith(
        isUploadingAvatar: false,
        actionMessage: failure.message,
      )),
      (_) async {
        final refreshed = await customerRepository.getAccountSettings();
        if (isClosed) return;
        emit(state.copyWith(
          isUploadingAvatar: false,
          settings: refreshed.fold((_) => null, (s) => s),
          actionMessage: 'تم تحديث صورتك',
        ));
      },
    );
  }

  Future<void> save(AccountSettings settings) async {
    if (state.isSaving) return;

    if (settings.fullName.isEmpty) {
      emit(state.copyWith(actionMessage: 'الاسم مطلوب'));
      return;
    }

    emit(state.copyWith(isSaving: true));

    final result = await customerRepository.updateAccountSettings(settings);
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(
        isSaving: false,
        actionMessage: failure.message,
      )),
      (saved) => emit(state.copyWith(
        isSaving: false,
        settings: saved,
        actionMessage: 'تم حفظ التغييرات',
      )),
    );
  }
}
