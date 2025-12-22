import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:masjid_sabilillah/data/models/prayer_time_model.dart';

class ApiService {
  static const String baseUrl = 'https://api.aladhan.com/v1/timingsByCity';
  static const int connectionTimeout = 30; // 30 detik - Android network lebih lambat
  
  Future<PrayerTime> getPrayerTimes({
    String city = 'Surabaya',
    String country = 'ID',
  }) async {
    try {
      final url = Uri.parse(
        '$baseUrl?city=$city&country=$country&method=5&timeformat=1',
      );

      print('[API Service] 📡 Requesting: $url');

      // Lebih toleran untuk timeout - Android sering lebih lambat
      final response = await http
          .get(
            url,
            headers: {
              'Accept': 'application/json',
              'Accept-Encoding': 'gzip, deflate',
              'Accept-Language': 'id-ID,id;q=0.9,en;q=0.8',
              'User-Agent': 'MySabilillah/1.0 (Android)',
              'Connection': 'keep-alive',
              'Cache-Control': 'max-age=3600',
            },
          )
          .timeout(
            Duration(seconds: connectionTimeout),
            onTimeout: () {
              print('[API Service] ⏱️ Request timeout after $connectionTimeout seconds');
              throw SocketException('API request timeout setelah $connectionTimeout detik - Cek koneksi internet Anda');
            },
          );

      print('[API Service] ✅ Status Code: ${response.statusCode}');
      print('[API Service] 📊 Response Size: ${response.contentLength} bytes');
      
      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          
          // Validate response structure
          if (!data.containsKey('data')) {
            throw Exception('Invalid API response structure: missing "data" key');
          }
          
          final d = data['data'];
          if (!d.containsKey('timings')) {
            throw Exception('Invalid API response structure: missing "timings"');
          }
          
          final t = d['timings'];
          final date = d['date']['gregorian']['date'];

          print('[API Service] ✅ API Success! Jadwal sholat berhasil dimuat.');
          print('[API Service] 📅 Date: $date');
          print('[API Service] 🕌 Timings: Fajr=${t['Fajr']}, Dhuhr=${t['Dhuhr']}, Asr=${t['Asr']}, Maghrib=${t['Maghrib']}, Isha=${t['Isha']}');
          
          return PrayerTime(
            tanggal: date,
            subuh: t['Fajr'],
            dzuhur: t['Dhuhr'],
            ashar: t['Asr'],
            maghrib: t['Maghrib'],
            isya: t['Isha'],
          );
        } catch (e) {
          print('[API Service] ❌ JSON Parse Error: $e');
          throw Exception('Gagal parse data jadwal sholat: $e');
        }
      } else if (response.statusCode == 400) {
        final errorBody = response.body;
        print('[API Service] ❌ Bad Request (400): $errorBody');
        throw Exception('❌ Bad Request: Cek nama kota atau negara');
      } else if (response.statusCode == 429) {
        print('[API Service] ⚠️ Rate Limited (429)');
        throw Exception('⚠️ Terlalu banyak request ke API - Silahkan tunggu 1 menit');
      } else if (response.statusCode >= 500) {
        print('[API Service] ❌ Server Error (${response.statusCode})');
        throw Exception('❌ Server API sedang tidak tersedia - Coba lagi nanti');
      } else {
        print('[API Service] ❌ HTTP Error (${response.statusCode}): ${response.body}');
        throw Exception('❌ Error ${response.statusCode}: Gagal mengambil jadwal sholat');
      }
    } on SocketException catch (e) {
      print('[API Service] ❌ SocketException: $e');
      throw Exception('❌ Masalah koneksi internet: Pastikan internet Anda aktif dan stabil');
    } on TimeoutException catch (e) {
      print('[API Service] ❌ TimeoutException: $e');
      throw Exception('⏱️ Request timeout - Internet/API terlalu lambat');
    } on FormatException catch (e) {
      print('[API Service] ❌ FormatException: $e');
      throw Exception('❌ Response format tidak valid: $e');
    } catch (e) {
      print('[API Service] ❌ Unexpected Error: $e');
      rethrow;
    }
  }
}