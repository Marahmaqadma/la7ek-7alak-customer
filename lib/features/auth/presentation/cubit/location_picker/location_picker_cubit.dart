import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/helpers/location_helper.dart';

part 'location_picker_state.dart';

// يدير دبوس اختيار الموقع في التسجيل: تحريكه بالضغط على الخريطة،
// أو نقله لموقع الجوال عبر زر "موقعي".
class LocationPickerCubit extends Cubit<LocationPickerState> {
  // بداية افتراضية: مدينة غزة.
  static const double defaultLatitude = 31.5017;
  static const double defaultLongitude = 34.4668;

  final Future<({double latitude, double longitude})> Function() _locate;

  LocationPickerCubit({
    double? initialLatitude,
    double? initialLongitude,
    Future<({double latitude, double longitude})> Function()? locate,
  })  : _locate = locate ?? _deviceLocation,
        super(LocationPickerState(
          latitude: initialLatitude ?? defaultLatitude,
          longitude: initialLongitude ?? defaultLongitude,
        ));

  static Future<({double latitude, double longitude})> _deviceLocation() async {
    final position = await LocationHelper.getCurrentLocation();
    return (latitude: position.latitude, longitude: position.longitude);
  }

  // الضغط على الخريطة ينقل الدبوس للنقطة.
  void selectPoint(double latitude, double longitude) =>
      emit(state.copyWith(latitude: latitude, longitude: longitude));

  // زر "موقعي": ينقل الدبوس والكاميرا لموقع الجوال.
  Future<void> locate() async {
    if (state.locating) return;
    emit(state.copyWith(locating: true));
    try {
      final location = await _locate();
      if (isClosed) return;
      emit(state.copyWith(
        locating: false,
        latitude: location.latitude,
        longitude: location.longitude,
        cameraRequest: state.cameraRequest + 1,
      ));
    } catch (error) {
      if (isClosed) return;
      emit(state.copyWith(
        locating: false,
        actionMessage: error is Exception
            ? error.toString().replaceFirst('Exception: ', '')
            : 'تعذر تحديد موقعك. اختره على الخريطة.',
      ));
    }
  }
}
