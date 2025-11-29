import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/location_controller.dart';
import 'package:flutter_map/plugin_api.dart';

class LocationView extends StatelessWidget {
  const LocationView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LocationController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Location Tracker'),
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: GetBuilder<LocationController>(
              builder: (controller) {
                return FlutterMap(
                  options: MapOptions(
                    center: controller.mapCenter.value,
                    zoom: controller.mapZoom.value,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.masjid_sabilillah',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: LatLng(
                            controller.currentPosition.value.latitude,
                            controller.currentPosition.value.longitude,
                          ),
                          builder: (context) => Container(
                            decoration: BoxDecoration(
                              color: controller.isGpsEnabled.value
                                  ? Colors.red.withOpacity(0.8)
                                  : Colors.blue.withOpacity(0.8),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          GetBuilder<LocationController>(
            builder: (controller) {
              return Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (controller.isTracking.value)
                        const Row(
                          children: [
                            Icon(Icons.circle, color: Colors.red, size: 12),
                            const SizedBox(width: 8),
                            Text(
                              'LIVE',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 8),
                      Text(
                        controller.isGpsEnabled.value
                            ? 'GPS Provider Location'
                            : 'Network Provider Location',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        'Latitude',
                        controller.currentPosition.value.latitude
                            .toStringAsFixed(6),
                      ),
                      _buildInfoRow(
                        'Longitude',
                        controller.currentPosition.value.longitude
                            .toStringAsFixed(6),
                      ),
                      _buildInfoRow(
                        'Accuracy',
                        '${controller.currentPosition.value.accuracy.toStringAsFixed(2)} m',
                      ),
                      _buildInfoRow(
                        'Timestamp',
                        DateFormat(
                          'HH:mm:ss',
                        ).format(controller.currentPosition.value.timestamp),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          GetBuilder<LocationController>(
            builder: (controller) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.getLocation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lightPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text('Refresh Location'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: controller.isTracking.value
                          ? controller.stopTracking
                          : controller.startTracking,
                      icon: Icon(
                        controller.isTracking.value
                            ? Icons.stop_circle
                            : Icons.play_circle,
                        size: 40,
                        color: controller.isTracking.value
                            ? Colors.red
                            : AppColors.lightPrimary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          GetBuilder<LocationController>(
            builder: (controller) {
              return SwitchListTile(
                title: const Text('Use GPS Provider'),
                value: controller.isGpsEnabled.value,
                onChanged: (value) => controller.toggleGps(),
                activeColor: AppColors.lightPrimary,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
