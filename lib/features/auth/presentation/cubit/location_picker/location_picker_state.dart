part of 'location_picker_cubit.dart';

// حالة اختيار الموقع: مكان الدبوس، وتحميل الـ GPS، وطلب تحريك الكاميرا.
class LocationPickerState {
  final double latitude;
  final double longitude;
  final bool locating;
  // يزيد كلما احتجنا تحريك الكاميرا للدبوس (بعد زر "موقعي").
  final int cameraRequest;
  // رسالة لمرة واحدة تعرضها الواجهة كـ SnackBar.
  final String? actionMessage;

  const LocationPickerState({
    required this.latitude,
    required this.longitude,
    this.locating = false,
    this.cameraRequest = 0,
    this.actionMessage,
  });

  // actionMessage تُمسح إن لم تُمرَّر حتى لا تتكرر الرسالة.
  LocationPickerState copyWith({
    double? latitude,
    double? longitude,
    bool? locating,
    int? cameraRequest,
    String? actionMessage,
  }) {
    return LocationPickerState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locating: locating ?? this.locating,
      cameraRequest: cameraRequest ?? this.cameraRequest,
      actionMessage: actionMessage,
    );
  }
}
