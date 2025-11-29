import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/location_data.dart';

class LocationMap extends StatelessWidget {
  final LocationData? currentLocation;
  final List<LocationData> locationHistory;
  final bool showPath;

  const LocationMap({
    super.key,
    this.currentLocation,
    this.locationHistory = const [],
    this.showPath = true,
  });

  @override
  Widget build(BuildContext context) {
    LatLng center = currentLocation != null
        ? LatLng(currentLocation!.latitude, currentLocation!.longitude)
        : const LatLng(-6.2088, 106.8456); // Default: Jakarta

    List<LatLng> pathPoints = locationHistory
        .map((loc) => LatLng(loc.latitude, loc.longitude))
        .toList();

    return FlutterMap(
      options: MapOptions(
        initialCenter: center,
        initialZoom: 15.0,
        minZoom: 5.0,
        maxZoom: 18.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.tes',
        ),
        if (showPath && pathPoints.length > 1)
          PolylineLayer(
            polylines: [
              Polyline(
                points: pathPoints,
                strokeWidth: 3.0,
                color: Colors.blue,
              ),
            ],
          ),
        MarkerLayer(
          markers: [
            if (currentLocation != null)
              Marker(
                point: LatLng(
                  currentLocation!.latitude,
                  currentLocation!.longitude,
                ),
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            // Show history markers
            ...locationHistory.map((loc) {
              return Marker(
                point: LatLng(loc.latitude, loc.longitude),
                width: 20,
                height: 20,
                child: Icon(
                  Icons.circle,
                  color: loc.provider == 'network' ? Colors.orange : Colors.green,
                  size: 10,
                ),
              );
            }),
          ],
        ),
      ],
    );
  }
}

