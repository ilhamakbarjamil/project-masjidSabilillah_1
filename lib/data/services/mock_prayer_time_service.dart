import 'package:masjid_sabilillah/data/models/prayer_time_model.dart';

class MockPrayerTimeService {
  /// Mock data untuk testing jika API tidak accessible
  /// Gunakan ini untuk development/testing tanpa internet
  
  static Map<String, PrayerTime> getMockData() {
    return {
      'Surabaya': PrayerTime(
        tanggal: DateTime.now().toString().split(' ')[0],
        subuh: '04:45',
        dzuhur: '12:15',
        ashar: '15:40',
        maghrib: '18:15',
        isya: '19:30',
      ),
      'Jakarta': PrayerTime(
        tanggal: DateTime.now().toString().split(' ')[0],
        subuh: '04:50',
        dzuhur: '12:20',
        ashar: '15:45',
        maghrib: '18:20',
        isya: '19:35',
      ),
      'Bandung': PrayerTime(
        tanggal: DateTime.now().toString().split(' ')[0],
        subuh: '04:55',
        dzuhur: '12:25',
        ashar: '15:50',
        maghrib: '18:25',
        isya: '19:40',
      ),
      'Medan': PrayerTime(
        tanggal: DateTime.now().toString().split(' ')[0],
        subuh: '04:35',
        dzuhur: '12:05',
        ashar: '15:30',
        maghrib: '18:05',
        isya: '19:20',
      ),
      'Makassar': PrayerTime(
        tanggal: DateTime.now().toString().split(' ')[0],
        subuh: '04:55',
        dzuhur: '12:00',
        ashar: '15:20',
        maghrib: '17:55',
        isya: '19:10',
      ),
      'Yogyakarta': PrayerTime(
        tanggal: DateTime.now().toString().split(' ')[0],
        subuh: '04:50',
        dzuhur: '12:10',
        ashar: '15:35',
        maghrib: '18:10',
        isya: '19:25',
      ),
      'Semarang': PrayerTime(
        tanggal: DateTime.now().toString().split(' ')[0],
        subuh: '04:50',
        dzuhur: '12:15',
        ashar: '15:40',
        maghrib: '18:15',
        isya: '19:30',
      ),
      'Malang': PrayerTime(
        tanggal: DateTime.now().toString().split(' ')[0],
        subuh: '04:45',
        dzuhur: '12:10',
        ashar: '15:35',
        maghrib: '18:10',
        isya: '19:25',
      ),
    };
  }

  static PrayerTime getMockDataForCity(String city) {
    final mockData = getMockData();
    return mockData[city] ?? mockData['Surabaya']!;
  }
}
