import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/services/storage_service.dart';

part 'home_state.dart';

// يدير بيانات حساب المستهلك والتبويب المختار والصورة الشخصية.
class HomeCubit extends Cubit<HomeState> {
  final StorageService storageService;
  final ImagePicker imagePicker;

  HomeCubit(
    this.storageService, {
    ImagePicker? imagePicker,
  })  : imagePicker = imagePicker ?? ImagePicker(),
        super(const HomeState());

  // يحمّل المدينة والاسم ومسار الصورة مع قيم بديلة عند غيابها.
  Future<void> loadUserProfile() async {
    final city = await storageService.getSelectedCity();
    final fullName = await storageService.getUserFullName();
    final profileImagePath = await storageService.getProfileImagePath();

    // إصدار نسخة جديدة من البيانات ليُعاد بناء الواجهة.
    emit(
      state.copyWith(
        city: city ?? 'اختر مدينتك',
        fullName: fullName ?? 'المستخدم',
        profileImagePath: profileImagePath,
      ),
    );
  }

  // يصدر حالة جديدة تحمل رقم التبويب الذي اختاره المستخدم.
  void changeTab(int index) {
    emit(state.copyWith(selectedTabIndex: index));
  }

  // يطلب صورة من الكاميرا أو المعرض ويحفظ مسارها ثم يحدّث الواجهة.
  Future<void> pickProfileImage(ImageSource source) async {
    final image = await imagePicker.pickImage(source: source);

    // إلغاء اختيار الصورة لا يغيّر الصورة الحالية.
    if (image == null) return;

    await storageService.saveProfileImagePath(image.path);
    emit(state.copyWith(profileImagePath: image.path));
  }
}
