import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/routing/app_router.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/entities/map_store.dart';
import '../cubit/stores_map_cubit/stores_map_cubit.dart';
import '../widgets/common/customer_page_header.dart';
import '../widgets/stores_map/map_category_chips.dart';
import '../widgets/stores_map/map_search_bar.dart';
import '../widgets/stores_map/map_store_marker.dart';

// صفحة خريطة المتاجر: تقرأ حالة StoresMapCubit وتزوّد StoresMapView بها.
// الـ cubit يُنشأ في الـ router (AppRouter.storesMap).
class StoresMapPage extends StatelessWidget {
  const StoresMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StoresMapCubit>();

    return BlocConsumer<StoresMapCubit, StoresMapState>(
      listenWhen: (_, curr) => curr.actionMessage != null,
      listener: (context, state) => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(state.actionMessage!, textAlign: TextAlign.right),
        )),
      builder: (context, state) => StoresMapView(
        stores: state.visibleStores,
        categories: [
          for (final c in state.categories) (id: c.id, name: c.name),
        ],
        selectedCategoryId: state.selectedCategoryId,
        isLoading: state.status == MapStoresStatus.loading,
        isLocating: state.locating,
        myLocation: state.myLocation,
        cameraRequest: state.cameraRequest,
        onBoundsChanged: (bounds) => cubit.loadArea(
          south: bounds.south,
          north: bounds.north,
          west: bounds.west,
          east: bounds.east,
        ),
        onSearchChanged: cubit.search,
        onCategorySelected: cubit.selectCategory,
        onLocateTap: cubit.locate,
        onStoreTap: (store) => Navigator.pushNamed(
          context,
          AppRouter.storeProfile,
          arguments: store.id,
        ),
      ),
    );
  }
}

// واجهة الخريطة: تعرض ما يصلها وتبلّغ عن التفاعلات. تحتفظ فقط بمتحكم
// الخريطة لأنه جزء من الواجهة (تحريك الكاميرا).
class StoresMapView extends StatefulWidget {
  final List<MapStore> stores;
  final List<({int id, String name})> categories;
  final int? selectedCategoryId;
  final bool isLoading;
  final bool isLocating;
  final ({double latitude, double longitude})? myLocation;
  // تغيّره يعني: حرّكي الكاميرا إلى myLocation.
  final int cameraRequest;
  final ValueChanged<LatLngBounds> onBoundsChanged;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<int> onCategorySelected;
  final VoidCallback onLocateTap;
  final ValueChanged<MapStore> onStoreTap;

  const StoresMapView({
    super.key,
    required this.stores,
    required this.categories,
    required this.selectedCategoryId,
    required this.isLoading,
    required this.isLocating,
    required this.myLocation,
    required this.cameraRequest,
    required this.onBoundsChanged,
    required this.onSearchChanged,
    required this.onCategorySelected,
    required this.onLocateTap,
    required this.onStoreTap,
  });

  @override
  State<StoresMapView> createState() => _StoresMapViewState();
}

class _StoresMapViewState extends State<StoresMapView> {
  // نقطة البداية: وسط قطاع غزة بحيث يظهر القطاع كله تقريبًا.
  static const _initialCenter = LatLng(31.42, 34.38);
  static const _initialZoom = 11.0;

  final _mapController = MapController();

  @override
  void didUpdateWidget(covariant StoresMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final location = widget.myLocation;
    if (location != null && widget.cameraRequest != oldWidget.cameraRequest) {
      _mapController.move(LatLng(location.latitude, location.longitude), 15);
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Stack(
          children: [
            Positioned.fill(child: _buildMap()),
            Column(
              children: [
                const CustomerPageHeader(title: ''),
                SizedBox(height: 14.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: MapSearchBar(onChanged: widget.onSearchChanged),
                ),
                SizedBox(height: 10.h),
                MapCategoryChips(
                  categories: widget.categories,
                  selectedId: widget.selectedCategoryId,
                  onSelected: widget.onCategorySelected,
                ),
                if (widget.isLoading)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 6.h,
                    ),
                    child: const LinearProgressIndicator(
                      minHeight: 2,
                      color: AppColors.orangeF58B1F,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
              ],
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: FloatingActionButton(
          tooltip: 'موقعي',
          backgroundColor: AppColors.orangeF58B1F,
          foregroundColor: AppColors.white,
          shape: const CircleBorder(),
          onPressed: widget.isLocating ? null : widget.onLocateTap,
          child: widget.isLocating
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.white,
                  ),
                )
              : const Icon(Icons.near_me_outlined),
        ),
      ),
    );
  }

  Widget _buildMap() {
    final location = widget.myLocation;

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _initialCenter,
        initialZoom: _initialZoom,
        // أول تحميل عند جاهزية الخريطة، ثم مع كل تحريك أو تكبير.
        onMapReady: () =>
            widget.onBoundsChanged(_mapController.camera.visibleBounds),
        onPositionChanged: (position, _) {
          final bounds = position.bounds;
          if (bounds != null) widget.onBoundsChanged(bounds);
        },
      ),
      children: [
        // خرائط OpenStreetMap مجانية وبدون مفتاح.
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.la7ek_7alak',
        ),
        MarkerLayer(
          markers: [
            for (final store in widget.stores)
              Marker(
                point: LatLng(store.latitude, store.longitude),
                width: mapStoreMarkerWidth,
                height: mapStoreMarkerHeight,
                // طرف العلامة الأيسر (النقطة) على موقع المتجر.
                alignment: Alignment.centerRight,
                child: MapStoreMarker(
                  name: store.name,
                  area: store.area,
                  imageUrl: store.imageUrl,
                  activeOffersCount: store.activeOffersCount,
                  onTap: () => widget.onStoreTap(store),
                ),
              ),
            if (location != null)
              Marker(
                point: LatLng(location.latitude, location.longitude),
                width: 22,
                height: 22,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2F80ED),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 3),
                  ),
                ),
              ),
          ],
        ),
        // شرط استخدام خرائط OpenStreetMap: ذكر المصدر.
        const Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.all(4),
            child: Text(
              '© OpenStreetMap',
              textDirection: TextDirection.ltr,
              style: TextStyle(fontSize: 10, color: Colors.black54),
            ),
          ),
        ),
      ],
    );
  }
}
