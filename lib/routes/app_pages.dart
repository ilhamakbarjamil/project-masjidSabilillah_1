import 'package:get/get.dart';
import '../features/location/bindings/location_binding.dart';
import '../features/location/bindings/network_location_binding.dart';
import '../features/location/bindings/gps_location_binding.dart';
import '../features/location/views/location_view.dart';
import '../features/location/views/network_location_view.dart';
import '../features/location/views/gps_location_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOCATION;

  static final routes = [
    GetPage(
      name: Routes.LOCATION,
      page: () => const LocationView(),
      binding: LocationBinding(),
    ),
    GetPage(
      name: Routes.NETWORK_LOCATION,
      page: () => const NetworkLocationView(),
      binding: NetworkLocationBinding(),
    ),
    GetPage(
      name: Routes.GPS_LOCATION,
      page: () => const GpsLocationView(),
      binding: GpsLocationBinding(),
    ),
  ];
}