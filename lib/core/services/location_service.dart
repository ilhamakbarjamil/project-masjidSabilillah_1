import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  Future<bool> requestPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<Position> getCurrentPosition({bool useGps = false}) async {
    if (await requestPermission()) {
      if (await isLocationServiceEnabled()) {
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: useGps ? LocationAccuracy.high : LocationAccuracy.low,
        );
      } else {
        throw Exception("Layanan lokasi dinonaktifkan");
      }
    } else {
      throw Exception("Izin lokasi ditolak");
    }
  }

  Stream<Position> getPositionStream({bool useGps = false}) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: useGps
            ? LocationAccuracy.high
            : LocationAccuracy.low,
        distanceFilter: 5, // Minimal perubahan 5 meter
      ),
    );
  }
}