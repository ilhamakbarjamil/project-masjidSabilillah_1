// lib/presentation/screens/prayer_times_screen.dart
import 'package:flutter/material.dart';
import 'package:masjid_sabilillah/data/models/prayer_time_model.dart';
import 'package:masjid_sabilillah/data/services/cached_api_service.dart';
import 'package:masjid_sabilillah/data/services/notification_service.dart';
import 'package:masjid_sabilillah/data/services/local_storage_service.dart';
import 'package:masjid_sabilillah/core/constants/indonesian_cities.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  late String _selectedCity;
  late Future<PrayerTime> _futurePrayer;
  final _cachedApiService = CachedApiService();

  @override
  void initState() {
    super.initState();
    _selectedCity = IndonesianCities.getDefaultCity();
    _loadCity();
    _futurePrayer = _fetchPrayerTimes();
  }

  Future<void> _loadCity() async {
    final city = await LocalStorageService().getCity();
    if (mounted) {
      setState(() {
        _selectedCity = city.isEmpty ? IndonesianCities.getDefaultCity() : city;
      });
    }
  }

  Future<PrayerTime> _fetchPrayerTimes() async {
    await _cachedApiService.init();
    return _cachedApiService.getPrayerTimesWithCache(city: _selectedCity);
  }

  void _onCityChanged(String? newCity) {
    if (newCity != null && newCity != _selectedCity) {
      setState(() {
        _selectedCity = newCity;
        _futurePrayer = _fetchPrayerTimes();
      });
      // Save selected city to local storage
      LocalStorageService().saveCity(newCity);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF00695C);
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        future: _futurePrayer,
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
                  // 0. CITY SELECTOR DROPDOWN
                  _buildCitySelector(primaryColor, isDark),
                  
                  const SizedBox(height: 20),

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
                    "Data diperbarui berdasarkan kota yang dipilih.",
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

  // Widget: City Selector Dropdown
  Widget _buildCitySelector(Color primaryColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
        ),
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
          Icon(PhosphorIconsFill.mapPin, color: primaryColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButton<String>(
              value: _selectedCity,
              isExpanded: true,
              underline: const SizedBox(),
              items: IndonesianCities.cities.map<DropdownMenuItem<String>>((String city) {
                return DropdownMenuItem<String>(
                  value: city,
                  child: Text(
                    city,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                );
              }).toList(),
              onChanged: _onCityChanged,
              dropdownColor: isDark ? Colors.grey[850] : Colors.white,
              borderRadius: BorderRadius.circular(12),
              icon: Icon(
                Icons.expand_more,
                color: primaryColor,
              ),
              iconSize: 24,
            ),
          ),
        ],
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
          Text(
            _selectedCity,
            style: const TextStyle(color: Colors.white70, fontSize: 14, letterSpacing: 1.2),
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
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  PhosphorIcons.warningCircle(), 
                  color: Colors.red, 
                  size: 60
                ),
              ),
              const SizedBox(height: 24),
              
              // Title
              const Text(
                'Gagal memuat jadwal sholat',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              // Requirements
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(PhosphorIcons.wifiHigh(), color: Colors.orange, size: 18),
                        const SizedBox(width: 8),
                        const Expanded(child: Text('Internet stabil')),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(PhosphorIcons.mapPin(), color: Colors.orange, size: 18),
                        const SizedBox(width: 8),
                        const Expanded(child: Text('GPS/Lokasi aktif')),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(PhosphorIcons.building(), color: Colors.orange, size: 18),
                        const SizedBox(width: 8),
                        const Expanded(child: Text('Coba ganti kota')),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Retry Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    debugPrint('[PrayerTimesScreen] User clicked Coba Lagi');
                    setState(() {
                      _futurePrayer = _fetchPrayerTimes();
                    });
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                ),
              ),
              const SizedBox(height: 12),
              
              // Back Button
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                    debugPrint('[PrayerTimesScreen] User clicked Kembali ke Home');
                    Get.offNamed('/');
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Kembali ke Home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}