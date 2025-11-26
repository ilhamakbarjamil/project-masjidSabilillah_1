// lib/data/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:masjid_sabilillah/data/models/prayer_time_model.dart';

class ApiService {
  Future<PrayerTime> getPrayerTimes({
    String city = 'Jombang',
    String country = 'ID',
  }) async {
    // Gunakan HTTPS + timeformat=1 (HH:mm saja) + method=5 (Kemenag Indonesia)
    final url = Uri.parse(
      'https://api.aladhan.com/v1/timingsByCity?city=$city&country=$country&method=5&timeformat=1',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PrayerTime.fromJson(data);
    } else {
      throw Exception('Gagal mengambil jadwal sholat (status: ${response.statusCode})');
    }
  }
}