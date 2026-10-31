import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';
import 'package:latlong2/latlong.dart';

import '../cubit/location_picker/location_picker_cubit.dart';

// نتيجة شاشة اختيار الموقع (عند "تأكيد الموقع")؛ null عند الرجوع.
typedef PickedLocation = ({double latitude, double longitude});

// شاشة اختيار موقع الزبون عند التسجيل على خريطة OpenStreetMap المجانية.
// تقرأ حالة LocationPickerCubit (يُنشأ في AppRouter.locationPicker) وترجع
// النقطة المؤكدة بـ Navigator.pop.
class LocationPickerPage extends StatelessWidget {
  const LocationPickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LocationPickerCubit>();

    return BlocConsumer<LocationPickerCubit, LocationPickerState>(
      listenWhen: (_, curr) => curr.actionMessage != null,
      listener: (context, state) => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(state.actionMessage!, textAlign: TextAlign.right),
        )),
      builder: (context, state) => LocationPickerView(
        latitude: state.latitude,
        longitude: state.longitude,
        isLocating: state.locating,
        cameraRequest: state.cameraRequest,
        onMapTap: cubit.selectPoint,
        onLocateTap: cubit.locate,
        onConfirm: () => Navigator.pop<PickedLocation>(
          context,
          (latitude: state.latitude, longitude: state.longitude),
        ),
      ),
    );
  }
}

// واجهة اختيار الموقع فقط. تحتفظ بمتحكم الخريطة لأنه جزء من الواجهة.
class LocationPickerView extends StatefulWidget {
  final double latitude;
  final double longitude;
  final bool isLocating;
  // تغيّره يعني: حرّكي الكاميرا إلى الدبوس.
  final int cameraRequest;
  final void Function(double latitude, double longitude) onMapTap;
  final VoidCallback onLocateTap;
  final VoidCallback onConfirm;

  const LocationPickerView({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.isLocating,
    required this.cameraRequest,
    required this.onMapTap,
    required this.onLocateTap,
    required this.onConfirm,
  });

  @override
  State<LocationPickerView> createState() => _LocationPickerViewState();
}

class _LocationPickerViewState extends State<LocationPickerView> {
  final _mapController = MapController();

  @override
  void didUpdateWidget(covariant LocationPickerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cameraRequest != oldWidget.cameraRequest) {
      _mapController.move(LatLng(widget.latitude, widget.longitude), 16);
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pin = LatLng(widget.latitude, widget.longitude);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: pin,
                initialZoom: 14,
                onTap: (_, point) =>
                    widget.onMapTap(point.latitude, point.longitude),
              ),
              children: [
                // خرائط OpenStreetMap مجانية وبدون مفتاح.
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.la7ek_7alak',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: pin,
                      width: 44,
                      height: 44,
                      // رأس الدبوس السفلي على النقطة نفسها.
                      alignment: Alignment.topCenter,
                      child: const Icon(
                        Icons.location_on,
                        size: 44,
                        color: AppColors.orangeF58B1F,
                      ),
                    ),
                  ],
                ),
                // شرط استخدام خرائط OpenStreetMap: ذكر المصدر.
                const Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 4, bottom: 72),
                    child: Text(
                      '© OpenStreetMap',
                      textDirection: TextDirection.ltr,
                      style: TextStyle(fontSize: 10, color: Colors.black54),
                    ),
                  ),
                ),
              ],
            ),
            // رجوع بدون حفظ (يُبقي المدينة المختارة سابقًا).
            Positioned(
              top: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Material(
                    color: Colors.white.withOpacity(0.9),
                    shape: const CircleBorder(),
                    child: IconButton(
                      tooltip: 'رجوع',
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.introNavy,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 72,
              right: 72,
              child: SafeArea(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'اضغط على الخريطة لتحديد موقعك',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 12,
                      color: AppColors.introNavy,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: FloatingActionButton(
          mini: true,
          tooltip: 'موقعي',
          backgroundColor: AppColors.introNavy,
          foregroundColor: Colors.white,
          onPressed: widget.isLocating ? null : widget.onLocateTap,
          child: widget.isLocating
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.my_location),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: ElevatedButton.icon(
              key: const ValueKey('confirm_location'),
              onPressed: widget.onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.introNavy,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.check_circle_outline, size: 20),
              label: const Text(
                'تأكيد الموقع',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
