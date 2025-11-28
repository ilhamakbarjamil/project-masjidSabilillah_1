// lib/presentation/screens/location_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:masjid_sabilillah/presentation/screens/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:masjid_sabilillah/core/constants/app_colors.dart';
import 'package:masjid_sabilillah/core/controllers/location_controller.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  // Koordinat Masjid Sabilillah (Sudah Benar)
  static const LatLng _mosqueLocation = LatLng(-7.5232396, 112.3511687);

  @override
  Widget build(BuildContext context) {
    final locationController = Get.put(LocationController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lokasi Masjid'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        leading: IconButton(
          onPressed: () => Get.to(const HomeScreen()),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.to(const HomeScreen()),
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: Column(
        children: [
          // ✅ PETA DENGAN ERROR HANDLING LENGKAP
          Expanded(
            child: GetBuilder<LocationController>(
              builder: (controller) {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (controller.hasError.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 48),
                        const SizedBox(height: 8),
                        Text(
                          controller.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: controller.getCurrentLocation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.lightPrimary,
                          ),
                          child: const Text('Coba Lagi'),
                        ),
                        const SizedBox(height: 16),
                        // ✅ TOMBOL ALTERNATIF UNTUK EMULATOR
                        ElevatedButton(
                          onPressed: () {
                            // Fallback ke koordinat default
                            controller.currentPosition.value = Position(
                              latitude: _mosqueLocation.latitude,
                              longitude: _mosqueLocation.longitude,
                              timestamp: DateTime.now(),
                              accuracy: 0,
                              altitude: 0,
                              heading: 0,
                              speed: 0,
                              speedAccuracy: 0,
                              altitudeAccuracy: 0,
                              headingAccuracy: 0,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text('Lihat Lokasi Masjid'),
                        ),
                      ],
                    ),
                  );
                }
                
                return GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      controller.currentPosition.value.latitude,
                      controller.currentPosition.value.longitude,
                    ),
                    zoom: 16,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('current_position'),
                      position: LatLng(
                        controller.currentPosition.value.latitude,
                        controller.currentPosition.value.longitude,
                      ),
                      infoWindow: const InfoWindow(title: 'Posisi Anda'),
                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                    ),
                    Marker(
                      markerId: const MarkerId('masjid_sabilillah'),
                      position: _mosqueLocation,
                      infoWindow: const InfoWindow(title: 'Masjid Sabilillah'),
                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                    ),
                  },
                  // ✅ TAMBAHKAN INI UNTUK MENCEGAH BLACK SCREEN
                  onMapCreated: (GoogleMapController controller) {
                    // Pastikan peta sudah terbentuk
                    debugPrint('Google Maps terinisialisasi');
                  },
                  // ✅ TAMBAHKAN INI UNTUK MENCEGAH BLACK SCREEN
                  onCameraMove: (CameraPosition position) {},
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: locationController.getCurrentLocation,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Perbarui Lokasi'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => _openGoogleMaps(context),
                  icon: const Icon(Icons.directions),
                  label: const Text('Arahkan ke Masjid'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                const SizedBox(height: 8),
                // ✅ ALAMAT LENGKAP
                Text(
                  'Jl. Panglima Sudirman, Kabupaten Mojokerto, Jawa Timur',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openGoogleMaps(BuildContext context) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=${_mosqueLocation.latitude},${_mosqueLocation.longitude}';
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
        debugPrint('✅ Berhasil membuka Google Maps');
      } else {
        Get.snackbar(
          'Error',
          'Tidak bisa membuka Google Maps',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal membuka Google Maps: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}