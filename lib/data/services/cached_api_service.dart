import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:masjid_sabilillah/data/models/prayer_time_model.dart';
import 'package:masjid_sabilillah/data/services/api_service.dart';
import 'package:masjid_sabilillah/data/services/mock_prayer_time_service.dart';

class CachedApiService {
  static const String _cacheKeyPrefix = 'prayer_times_';
  static const String _cacheTimestampKeyPrefix = 'prayer_times_timestamp_';
  static const int _cacheValidityHours = 24; // Cache selama 24 jam

  final ApiService _apiService = ApiService();
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<PrayerTime> getPrayerTimesWithCache({
    String city = 'Surabaya',
    String country = 'ID',
  }) async {
    final cacheKey = '$_cacheKeyPrefix${city}_$country';
    final timestampKey = '$_cacheTimestampKeyPrefix${city}_$country';

    try {
      print('[CachedApiService] 🌐 Mencoba fetch dari API untuk kota: $city');
      
      // Try to fetch from API first
      final prayerTime = await _apiService.getPrayerTimes(city: city, country: country);
      
      // Cache the result
      await _cacheResult(cacheKey, timestampKey, prayerTime);
      
      print('[CachedApiService] ✅ Berhasil fetch dari API dan disimpan ke cache');
      return prayerTime;
    } catch (apiError) {
      print('[CachedApiService] ⚠️ API gagal: $apiError');
      print('[CachedApiService] 💾 Mencoba gunakan cache lokal...');
      
      try {
        // If API fails, try to get from cache
        final cachedData = await _getCachedResult(cacheKey, timestampKey);
        if (cachedData != null) {
          print('[CachedApiService] ✅ Data dimuat dari cache lokal');
          return cachedData;
        }
      } catch (cacheError) {
        print('[CachedApiService] ⚠️ Error membaca cache: $cacheError');
      }
      
      // If no cache available, use mock data as last resort
      try {
        print('[CachedApiService] 🎯 Cache tidak tersedia, menggunakan data default (mock)...');
        final mockData = MockPrayerTimeService.getMockDataForCity(city);
        
        // Cache the mock data for next time
        await _cacheResult(cacheKey, timestampKey, mockData);
        
        print('[CachedApiService] ℹ️ Menampilkan data default - Silakan coba lagi setelah internet stabil');
        return mockData;
      } catch (mockError) {
        print('[CachedApiService] ❌ Gagal load mock data: $mockError');
        // Rethrow dengan pesan yang jelas
        throw Exception('Gagal memuat jadwal sholat. Pastikan internet Anda stabil dan coba lagi.');
      }
    }
  }

  Future<void> _cacheResult(
    String cacheKey,
    String timestampKey,
    PrayerTime prayerTime,
  ) async {
    try {
      final jsonData = jsonEncode({
        'tanggal': prayerTime.tanggal,
        'subuh': prayerTime.subuh,
        'dzuhur': prayerTime.dzuhur,
        'ashar': prayerTime.ashar,
        'maghrib': prayerTime.maghrib,
        'isya': prayerTime.isya,
      });
      
      await _prefs.setString(cacheKey, jsonData);
      await _prefs.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch);
      
      print('[CachedApiService] Data cached successfully');
    } catch (e) {
      print('[CachedApiService] Error caching data: $e');
    }
  }

  Future<PrayerTime?> _getCachedResult(
    String cacheKey,
    String timestampKey,
  ) async {
    try {
      final jsonData = _prefs.getString(cacheKey);
      final timestamp = _prefs.getInt(timestampKey);

      if (jsonData == null || timestamp == null) {
        return null;
      }

      // Check if cache is still valid
      final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
      final cacheValidityMs = _cacheValidityHours * 60 * 60 * 1000;

      if (cacheAge > cacheValidityMs) {
        print('[CachedApiService] Cache expired');
        return null;
      }

      final data = jsonDecode(jsonData);
      
      return PrayerTime(
        tanggal: data['tanggal'],
        subuh: data['subuh'],
        dzuhur: data['dzuhur'],
        ashar: data['ashar'],
        maghrib: data['maghrib'],
        isya: data['isya'],
      );
    } catch (e) {
      print('[CachedApiService] Error reading cache: $e');
      return null;
    }
  }

  // Clear all cached data
  Future<void> clearCache() async {
    try {
      final keys = _prefs.getKeys().where((key) {
        return key.startsWith(_cacheKeyPrefix) || 
               key.startsWith(_cacheTimestampKeyPrefix);
      }).toList();
      
      for (final key in keys) {
        await _prefs.remove(key);
      }
      
      print('[CachedApiService] Cache cleared');
    } catch (e) {
      print('[CachedApiService] Error clearing cache: $e');
    }
  }
}
