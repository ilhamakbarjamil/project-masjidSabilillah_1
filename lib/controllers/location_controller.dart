import 'dart:async';
import 'package:get/get.dart';
import '../models/location_data.dart';
import '../services/location_service.dart';

class LocationController extends GetxController {
  final LocationService _locationService = LocationService();
  
  final Rx<LocationData?> currentLocation = Rx<LocationData?>(null);
  final RxList<LocationData> locationHistory = <LocationData>[].obs;
  final RxBool isTracking = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<LocationProvider?> currentProvider = Rx<LocationProvider?>(null);
  
  StreamSubscription<LocationData>? _locationSubscription;
  DateTime? _firstPositionTime;
  DateTime? get firstPositionTime => _firstPositionTime;

  @override
  void onInit() {
    super.onInit();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    bool hasPermission = await _locationService.requestPermissions();
    if (!hasPermission) {
      errorMessage.value = 'Location permissions denied';
    }
  }

  Future<void> startTracking(LocationProvider provider) async {
    try {
      // Stop any existing tracking first
      await stopTracking();
      
      // Wait a bit to ensure previous stream is fully closed
      await Future.delayed(const Duration(milliseconds: 300));
      
      isTracking.value = true;
      currentProvider.value = provider;
      locationHistory.clear();
      _firstPositionTime = null;
      errorMessage.value = '';

      // Subscribe to location stream
      _locationSubscription = _locationService.getLocationStream(provider).listen(
        (LocationData location) {
          currentLocation.value = location;
          locationHistory.add(location);
          
          if (_firstPositionTime == null) {
            _firstPositionTime = DateTime.now();
          }
        },
        onError: (error) {
          errorMessage.value = 'Error: $error';
          // Don't stop tracking on error, let it retry
          print('Location stream error: $error');
        },
        cancelOnError: false, // Continue listening even on error
      );
    } catch (e) {
      errorMessage.value = 'Failed to start tracking: $e';
      isTracking.value = false;
      print('Failed to start tracking: $e');
    }
  }

  Future<void> stopTracking() async {
    await _locationSubscription?.cancel();
    _locationSubscription = null;
    _locationService.stopLocationStream();
    isTracking.value = false;
    currentProvider.value = null;
  }

  Future<LocationData?> getSingleLocation(LocationProvider provider) async {
    try {
      errorMessage.value = '';
      LocationData? location = await _locationService.getCurrentLocation(provider);
      if (location != null) {
        currentLocation.value = location;
      }
      return location;
    } catch (e) {
      errorMessage.value = 'Failed to get location: $e';
      return null;
    }
  }

  void clearHistory() {
    locationHistory.clear();
    currentLocation.value = null;
    _firstPositionTime = null;
  }

  @override
  void onClose() {
    stopTracking();
    super.onClose();
  }
}

