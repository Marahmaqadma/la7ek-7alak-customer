import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/login_type_card.dart';

// يحفظ نوع المستخدم المختار لتحديث البطاقات ومسار الدخول.
class ChooseUserTypeCubit extends Cubit<LoginType> {
  ChooseUserTypeCubit() : super(LoginType.consumer);

  // يحدّث نوع الحساب المختار لتنعكس النتيجة على البطاقات.
  void selectType(LoginType type) {
    emit(type);
  }
}
