import 'package:get/get.dart';
import '../controllers/network_location_controller.dart';

class NetworkLocationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NetworkLocationController>(() => NetworkLocationController());
  }
}