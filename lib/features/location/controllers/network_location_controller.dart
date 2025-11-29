import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/services/location_service.dart';

class NetworkLocationController extends GetxController {
  final LocationService _locationService = LocationService();
  
  var currentPosition = Position(
    latitude: -7.5232396,
    longitude: 112.3511687,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    heading: 0,
    speed: 0,
    altitudeAccuracy: 0,
    headingAccuracy: 0,
    speedAccuracy: 0,
  ).obs;
  
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  var mapCenter = LatLng(-7.5232396, 112.3511687).obs;
  var mapZoom = 16.0.obs;

  Future<void> getLocation() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      
      final position = await _locationService.getCurrentPosition(
        useGps: false, // Network provider only
      );
      
      currentPosition.value = position;
      mapCenter.value = LatLng(position.latitude, position.longitude);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getLocation();
  }
}