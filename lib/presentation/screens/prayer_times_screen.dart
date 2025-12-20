// lib/presentation/screens/prayer_times_screen.dart
import 'package:flutter/material.dart';
import 'package:masjid_sabilillah/data/models/prayer_time_model.dart';
import 'package:masjid_sabilillah/data/services/api_service.dart';
import 'package:masjid_sabilillah/data/services/notification_service.dart';
import 'package:masjid_sabilillah/data/services/local_storage_service.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF00695C);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final futurePrayer = () async {
      final city = await LocalStorageService().getCity();
      return ApiService().getPrayerTimes(city: city);
    }();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1716) : const Color(0xFFF5F7F7),
      appBar: AppBar(
        title: const Text('Jadwal Sholat', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? Colors.white : primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Get.back(),
        ),
      ),
      body: FutureBuilder<PrayerTime>(
        future: futurePrayer,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: primaryColor));
          } else if (snapshot.hasError) {
            return _buildErrorState(primaryColor);
          } else if (snapshot.hasData) {
            final prayer = snapshot.data!;
            final prayerList = prayer.prayerList;
            // Tambahkan: Otomatis jadwalkan notifikasi sholat
            Future.microtask(() => NotificationService.schedulePrayerNotifications(prayer));

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // 1. HEADER CARD (Lokasi & Tanggal)
                  _buildHeaderCard(prayer, primaryColor, isDark),
                  
                  const SizedBox(height: 24),

                  // 2. LIST JADWAL
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: prayerList.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = prayerList[index];
                      return _buildPrayerTile(
                        item['name']!, 
                        item['time']!, 
                        _getIconForPrayer(item['name']!),
                        primaryColor, 
                        isDark
                      );
                    },
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // 3. FOOTER INFO
                  Text(
                    "Data diperbarui berdasarkan lokasi Anda.",
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Data tidak tersedia'));
          }
        },
      ),
    );
  }

  // Widget: Header (Location & Date)
  Widget _buildHeaderCard(PrayerTime prayer, Color primaryColor, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, const Color(0xFF004D40)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          Icon(PhosphorIconsFill.mapPin, color: Colors.white.withOpacity(0.8), size: 28),
          const SizedBox(height: 12),
          const Text(
            "Kota Anda", // Anda bisa mengganti ini dengan variabel city dari localStorage
            style: TextStyle(color: Colors.white70, fontSize: 14, letterSpacing: 1.2),
          ),
          const SizedBox(height: 4),
          Text(
            prayer.tanggal,
            style: const TextStyle(
              color: Colors.white, 
              fontSize: 20, 
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }

  // Widget: Prayer Time Row
  Widget _buildPrayerTile(String name, String time, IconData icon, Color primaryColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: primaryColor, size: 22),
          ),
          const SizedBox(width: 16),
          Text(
            name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          Text(
            time,
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold, 
              color: primaryColor
            ),
          ),
          const SizedBox(width: 4),
          const Text("WIB", style: TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  // Helper: Mapping Icons
  IconData _getIconForPrayer(String name) {
    switch (name.toLowerCase()) {
      case 'subuh': return PhosphorIconsFill.cloudFog;
      case 'terbit': return PhosphorIconsFill.sunHorizon;
      case 'dzuhur': return PhosphorIconsFill.sun;
      case 'ashar': return PhosphorIconsFill.cloudSun;
      case 'maghrib': return PhosphorIconsFill.sunHorizon;
      case 'isya': return PhosphorIconsFill.moon;
      default: return PhosphorIconsFill.clock;
    }
  }

  // Widget: Error State
  Widget _buildErrorState(Color primaryColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(PhosphorIcons.warningCircle(), color: Colors.red, size: 60),
          const SizedBox(height: 16),
          const Text('Gagal memuat jadwal sholat', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            onPressed: () => Get.offNamed('/jadwal'),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}