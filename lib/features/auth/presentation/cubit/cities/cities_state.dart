part of 'cities_cubit.dart';

enum CitiesStatus { initial, loading, loaded, error }

// قائمة المدن لحقل المدينة في التسجيل.
class CitiesState {
  final CitiesStatus status;
  final List<CityModel> cities;
  final String? error;

  const CitiesState({
    this.status = CitiesStatus.initial,
    this.cities = const [],
    this.error,
  });

  // أقرب مدينة لنقطة على الخريطة (حسب مركز كل مدينة)؛ null إن لم توجد
  // مدن بإحداثيات. المقارنة بمربع الفرق تكفي لمسافات قصيرة مثل غزة.
  CityModel? nearestCity(double latitude, double longitude) {
    CityModel? nearest;
    var best = double.infinity;
    for (final city in cities) {
      final lat = city.latitude;
      final lng = city.longitude;
      if (lat == null || lng == null) continue;
      final distance = (lat - latitude) * (lat - latitude) +
          (lng - longitude) * (lng - longitude);
      if (distance < best) {
        best = distance;
        nearest = city;
      }
    }
    return nearest;
  }

  CitiesState copyWith({
    CitiesStatus? status,
    List<CityModel>? cities,
    String? error,
  }) {
    return CitiesState(
      status: status ?? this.status,
      cities: cities ?? this.cities,
      error: error ?? this.error,
    );
  }
}
