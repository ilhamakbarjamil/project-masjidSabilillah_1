// lib/data/models/prayer_time_model.dart
class PrayerTime {
  final String subuh;
  final String dzuhur;
  final String ashar;
  final String maghrib;
  final String isya;
  final String tanggal;

  PrayerTime({
    required this.subuh,
    required this.dzuhur,
    required this.ashar,
    required this.maghrib,
    required this.isya,
    required this.tanggal,
  });

  factory PrayerTime.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final timings = data['timings'];
    final date = data['date']['gregorian']['date'];

    return PrayerTime(
      tanggal: date,
      subuh: _cleanTime(timings['Fajr']),
      dzuhur: _cleanTime(timings['Dhuhr']),
      ashar: _cleanTime(timings['Asr']),
      maghrib: _cleanTime(timings['Maghrib']),
      isya: _cleanTime(timings['Isha']),
    );
  }

  // Hapus keterangan seperti "(WIB)"
  static String _cleanTime(String time) {
    return time.split(' ')[0]; // Ambil bagian sebelum spasi
  }

  List<Map<String, String>> get prayerList => [
        {'name': 'Subuh', 'time': subuh},
        {'name': 'Dzuhur', 'time': dzuhur},
        {'name': 'Ashar', 'time': ashar},
        {'name': 'Maghrib', 'time': maghrib},
        {'name': 'Isya', 'time': isya},
      ];
}