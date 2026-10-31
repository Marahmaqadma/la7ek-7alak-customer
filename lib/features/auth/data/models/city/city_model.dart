// مدينة من GET api/cities:
// {id, governorate, area, latitude, longitude, createdAt}.
class CityModel {
  final int id;
  // اسم المنطقة الذي يظهر للمستخدم (مثل: النصيرات).
  final String area;
  final String governorate;
  // مركز المدينة؛ نستخدمه لاختيار أقرب مدينة للنقطة المختارة على الخريطة.
  final double? latitude;
  final double? longitude;

  const CityModel({
    required this.id,
    required this.area,
    required this.governorate,
    this.latitude,
    this.longitude,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: (json['id'] as num).toInt(),
      area: ((json['area'] as String?) ?? '').trim(),
      governorate: ((json['governorate'] as String?) ?? '').trim(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }
}
