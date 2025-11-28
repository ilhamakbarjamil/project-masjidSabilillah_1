// lib/core/controllers/location_controller.dart
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class LocationController extends GetxController {
  var currentPosition = Position(
    latitude: -7.5232396,
    longitude: 112.3511687,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
    altitudeAccuracy: 0,
    headingAccuracy: 0,
  ).obs;

  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  Future<void> getCurrentLocation() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      
      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        throw Exception("Aktifkan layanan lokasi di pengaturan perangkat");
      }

      final permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        final newPermission = await Geolocator.requestPermission();
        if (newPermission == LocationPermission.denied) {
          throw Exception("Izin lokasi ditolak");
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        throw Exception("Izin lokasi ditolak permanen - buka Pengaturan untuk mengaktifkan");
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      
      currentPosition.value = position;
      print('✅ Lokasi berhasil: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Error: ${e.toString().split(':').first}";
      print('❌ Error get location: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }
}