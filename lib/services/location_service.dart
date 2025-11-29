import 'dart:async';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/location_data.dart';

enum LocationProvider { network, gps }

class LocationService {
  Stream<LocationData>? _locationStream;
  StreamSubscription<Position>? _positionSubscription;
  StreamController<LocationData>? _streamController;
  LocationProvider? _currentProvider;

  Future<bool> requestPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    // Request background location if needed
    await Permission.locationAlways.request();
    
    return true;
  }

  Stream<LocationData> getLocationStream(LocationProvider provider) {
    // Stop existing stream first
    stopLocationStream();
    
    _currentProvider = provider;
    
    // Create location settings without cache
    LocationSettings locationSettings;
    
    if (Platform.isAndroid) {
      if (provider == LocationProvider.network) {
        locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.low,
          distanceFilter: 10, // meters
          forceLocationManager: false, // Use network provider
          intervalDuration: const Duration(seconds: 5), // Update every 5 seconds
        );
      } else {
        locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5, // meters
          forceLocationManager: true, // Force GPS, don't use network
          intervalDuration: const Duration(seconds: 3), // Update every 3 seconds
        );
      }
    } else {
      // iOS settings
      if (provider == LocationProvider.network) {
        locationSettings = AppleSettings(
          accuracy: LocationAccuracy.low,
          distanceFilter: 10,
        );
      } else {
        locationSettings = AppleSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 5,
        );
      }
    }

    // Create stream controller for better control
    _streamController = StreamController<LocationData>.broadcast();
    
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position position) {
        // Only add if position is fresh (not cached)
        final now = DateTime.now();
        final positionTime = position.timestamp;
        final age = now.difference(positionTime).inSeconds;
        
        // Reject positions older than 10 seconds (likely cached)
        if (age < 10) {
          _streamController?.add(
            LocationData(
              latitude: position.latitude,
              longitude: position.longitude,
              accuracy: position.accuracy,
              timestamp: position.timestamp,
              provider: provider == LocationProvider.network ? 'network' : 'gps',
            ),
          );
        }
      },
      onError: (error) {
        _streamController?.addError(error);
      },
      cancelOnError: false,
    );

    _locationStream = _streamController!.stream;
    return _locationStream!;
  }

  Future<LocationData?> getCurrentLocation(LocationProvider provider) async {
    try {
      LocationSettings locationSettings;
      
      if (Platform.isAndroid) {
        if (provider == LocationProvider.network) {
          locationSettings = AndroidSettings(
            accuracy: LocationAccuracy.low,
            forceLocationManager: false,
          );
        } else {
          locationSettings = AndroidSettings(
            accuracy: LocationAccuracy.high,
            forceLocationManager: true, // Force GPS
          );
        }
      } else {
        // iOS
        if (provider == LocationProvider.network) {
          locationSettings = AppleSettings(
            accuracy: LocationAccuracy.low,
          );
        } else {
          locationSettings = AppleSettings(
            accuracy: LocationAccuracy.best,
          );
        }
      }

      // Get fresh location, don't use cache
      // timeLimit ensures we get a fresh location
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
        timeLimit: const Duration(seconds: 15), // Max 15 seconds to get location
      );

      // Verify position is fresh (not cached)
      final now = DateTime.now();
      final positionTime = position.timestamp;
      final age = now.difference(positionTime).inSeconds;
      
      // Reject if position is older than 5 seconds
      if (age > 5) {
        // Try to get a new one
        position = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings,
          timeLimit: const Duration(seconds: 10),
        );
      }

      return LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        timestamp: position.timestamp,
        provider: provider == LocationProvider.network ? 'network' : 'gps',
      );
    } catch (e) {
      return null;
    }
  }

  void stopLocationStream() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
    _streamController?.close();
    _streamController = null;
    _locationStream = null;
    _currentProvider = null;
  }

  LocationProvider? get currentProvider => _currentProvider;
}

