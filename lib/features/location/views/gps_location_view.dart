import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/gps_location_controller.dart';
import 'package:flutter_map/plugin_api.dart';

class GpsLocationView extends StatelessWidget {
  const GpsLocationView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GpsLocationController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS Location'),
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: GetBuilder<GpsLocationController>(
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
                              color: Colors.red.withOpacity(0.8),
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
          GetBuilder<GpsLocationController>(
            builder: (controller) {
              return Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'GPS Location',
                        style: TextStyle(
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () => controller.getLocation(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 0),
              ),
              child: const Text('Refresh Location'),
            ),
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
