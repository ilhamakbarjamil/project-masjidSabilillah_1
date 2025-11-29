import 'package:get/get.dart';
import '../controllers/gps_location_controller.dart';

class GpsLocationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GpsLocationController>(() => GpsLocationController());
  }
}