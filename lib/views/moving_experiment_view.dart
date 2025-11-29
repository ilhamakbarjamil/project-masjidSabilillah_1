import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/location_controller.dart';
import '../controllers/experiment_controller.dart';
import '../services/location_service.dart';
import '../widgets/location_map.dart';

class MovingExperimentView extends StatelessWidget {
  const MovingExperimentView({super.key});

  @override
  Widget build(BuildContext context) {
    final LocationController locationController = Get.find<LocationController>();
    final ExperimentController experimentController = Get.find<ExperimentController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eksperimen 3: Bergerak (Real-time)'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Obx(() => Column(
        children: [
          // Map
          Expanded(
            child: LocationMap(
              currentLocation: locationController.currentLocation.value,
              locationHistory: locationController.locationHistory,
              showPath: true,
            ),
          ),
          
          // Controls and Info
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Provider Selection
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: locationController.isTracking.value &&
                                locationController.currentProvider.value == LocationProvider.network
                            ? null
                            : () async {
                                await locationController.stopTracking();
                                await locationController.startTracking(LocationProvider.network);
                              },
                        icon: const Icon(Icons.wifi),
                        label: const Text('Network Mode'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: locationController.isTracking.value &&
                                locationController.currentProvider.value == LocationProvider.gps
                            ? null
                            : () async {
                                await locationController.stopTracking();
                                await locationController.startTracking(LocationProvider.gps);
                              },
                        icon: const Icon(Icons.satellite),
                        label: const Text('GPS Mode'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Control Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: locationController.isTracking.value
                            ? () => locationController.stopTracking()
                            : null,
                        icon: const Icon(Icons.stop),
                        label: const Text('Stop'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          locationController.clearHistory();
                          experimentController.clearData();
                        },
                        icon: const Icon(Icons.clear),
                        label: const Text('Clear'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Current Location Info
                if (locationController.currentLocation.value != null)
                  _buildLocationInfo(locationController.currentLocation.value!),
                
                const SizedBox(height: 8),
                
                // Statistics
                _buildStatistics(locationController),
                
                if (locationController.errorMessage.value.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      locationController.errorMessage.value,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildLocationInfo(location) {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Location (${location.provider.toUpperCase()})',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text('Lat: ${location.latitude.toStringAsFixed(6)}'),
            Text('Lng: ${location.longitude.toStringAsFixed(6)}'),
            Text('Accuracy: ${location.accuracy?.toStringAsFixed(2) ?? "N/A"} m'),
            Text('Time: ${DateFormat('HH:mm:ss').format(location.timestamp)}'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatistics(LocationController controller) {
    final history = controller.locationHistory;
    final firstTime = controller.firstPositionTime;
    
    String? timeToFirstFix;
    if (firstTime != null && history.isNotEmpty) {
      final duration = history.first.timestamp.difference(firstTime);
      timeToFirstFix = '${duration.inSeconds}s';
    }

    return Card(
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistics',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text('Total Points: ${history.length}'),
            if (timeToFirstFix != null)
              Text('Time to First Fix: $timeToFirstFix'),
            if (history.length > 1)
              Text('Update Rate: ${history.length} points'),
            if (controller.currentProvider.value != null)
              Text(
                'Mode: ${controller.currentProvider.value == LocationProvider.network ? "Network" : "GPS"}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}

