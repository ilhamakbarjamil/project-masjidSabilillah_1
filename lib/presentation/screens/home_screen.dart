// lib/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:intl/intl.dart';
import 'package:masjid_sabilillah/data/models/prayer_time_model.dart';
import 'package:masjid_sabilillah/data/services/api_service.dart';
import 'package:masjid_sabilillah/data/services/local_storage_service.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  String? _userName;
  String _selectedCity = 'Surabaya'; // Default city
  final primaryColor = const Color(0xFF00695C);
  final accentColor = const Color(0xFF004D40);
  
  late Timer _timer;
  DateTime _currentTime = DateTime.now();
  PrayerTime? _todayPrayerTimes;
  String _nextPrayerName = 'Dzuhur';
  String _nextPrayerTime = '--:--';
  String _countdownTime = '00:00:00';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadUserData();
    _initializeData();
    
    // Update waktu dan countdown setiap 1 detik
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
          _updateNextPrayer();
        });
      }
    });
  }

  // Initialize: Load city dulu, baru load prayer times
  Future<void> _initializeData() async {
    await _loadCity();
    await _loadPrayerTimes();
  }

  @override
  void dispose() {
    _timer.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Deteksi ketika app kembali ke foreground (untuk reload data jika ada perubahan kota)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Force reload city dan prayer times setiap kali app kembali
      _forceReloadData();
    }
  }

  Future<void> _forceReloadData() async {
    try {
      final newCity = await LocalStorageService().getCity();
      final cityToUse = newCity.isEmpty ? 'Surabaya' : newCity;
      
      if (mounted) {
        setState(() {
          _selectedCity = cityToUse;
        });
        // Selalu reload prayer times saat app kembali
        await _loadPrayerTimes();
      }
    } catch (e) {
      debugPrint('Error reloading data: $e');
    }
  }

  Future<void> _loadCity() async {
    try {
      final city = await LocalStorageService().getCity();
      if (mounted) {
        setState(() {
          _selectedCity = city.isEmpty ? 'Surabaya' : city;
        });
      }
    } catch (e) {
      debugPrint('Error loading city: $e');
    }
  }

  Future<void> _loadPrayerTimes() async {
    try {
      final prayerTimes = await ApiService().getPrayerTimes(city: _selectedCity);
      if (mounted) {
        setState(() {
          _todayPrayerTimes = prayerTimes;
          _updateNextPrayer();
        });
      }
    } catch (e) {
      debugPrint('Error loading prayer times: $e');
    }
  }

  void _updateNextPrayer() {
    if (_todayPrayerTimes == null) return;

    final now = DateTime.now();
    final prayerList = _todayPrayerTimes!.prayerList;
    
    DateTime? nextPrayerDateTime;
    String? nextPrayerName;
    
    // Cek setiap jadwal sholat
    for (var prayer in prayerList) {
      final prayerTimeStr = prayer['time'] as String;
      final prayerName = prayer['name'] as String;
      
      // Parse waktu sholat (format HH:mm)
      final parts = prayerTimeStr.split(':');
      if (parts.length == 2) {
        final hour = int.tryParse(parts[0]) ?? 0;
        final minute = int.tryParse(parts[1]) ?? 0;
        
        final prayerDateTime = DateTime(now.year, now.month, now.day, hour, minute);
        
        // Jika jadwal sholat masih belum tiba dan lebih dekat dari yang sebelumnya
        if (prayerDateTime.isAfter(now)) {
          if (nextPrayerDateTime == null || prayerDateTime.isBefore(nextPrayerDateTime)) {
            nextPrayerDateTime = prayerDateTime;
            nextPrayerName = prayerName;
          }
        }
      }
    }
    
    // Set default jika tidak ada yang ditemukan (sholat sudah selesai hari ini)
    if (nextPrayerDateTime == null) {
      _nextPrayerName = prayerList.first['name'] ?? 'Subuh';
      _nextPrayerTime = prayerList.first['time'] ?? '--:--';
      _countdownTime = 'Besok';
    } else {
      _nextPrayerName = nextPrayerName ?? 'Dzuhur';
      _nextPrayerTime = _formatTime(nextPrayerDateTime);
      _countdownTime = _calculateCountdown(nextPrayerDateTime);
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _calculateCountdown(DateTime targetTime) {
    final now = DateTime.now();
    final difference = targetTime.difference(now);
    
    if (difference.isNegative) {
      return '00:00:00';
    }
    
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);
    final seconds = difference.inSeconds.remainder(60);
    
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _loadUserData() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null && user.email != null) {
        final name = user.email!.split('@')[0];
        final formattedName = name[0].toUpperCase() + name.substring(1);
        if (mounted) setState(() => _userName = formattedName);
      }
    } catch (e) {
      debugPrint('Error load user: $e');
    }
  }

  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  // Method untuk refresh data dari UI
  Future<void> _refreshData() async {
    debugPrint('🔄 Refreshing home screen data...');
    await _forceReloadData();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1716) : const Color(0xFFF5F7F7),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: primaryColor,
        child: CustomScrollView(
          slivers: [
            // 1. APP BAR MODERN
            SliverAppBar(
              expandedHeight: 180.0,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: primaryColor,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, accentColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                  children: [
                    // Pattern Islami Transparan
                    Positioned(
                      right: -50,
                      top: -20,
                      child: Opacity(
                        opacity: 0.1,
                        child: Icon(PhosphorIcons.mosque(), size: 250, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Assalamu\'alaikum,',
                            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16),
                          ),
                          Text(
                            _userName ?? 'Hamba Allah',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => Get.toNamed('/pengaturan'),
                icon: const Icon(PhosphorIconsFill.gearSix, color: Colors.white),
              ),
              const SizedBox(width: 8),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. KARTU JADWAL SHOLAT (Next Prayer Highlight)
                  _buildNextPrayerCard(isDark),

                  const SizedBox(height: 30),

                  // 3. MENU GRID
                  const Text(
                    'Layanan Masjid',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    children: [
                      _buildMenuCard(
                        'Jadwal Sholat',
                        PhosphorIconsFill.clock,
                        Colors.blue,
                        '/jadwal',
                        isDark,
                      ),
                      _buildMenuCard(
                        'Infaq/Donasi',
                        PhosphorIconsFill.handHeart,
                        Colors.orange,
                        '/donasi',
                        isDark,
                      ),
                      _buildMenuCard(
                        'Pengumuman',
                        PhosphorIconsFill.megaphone,
                        Colors.purple,
                        '/pengumuman',
                        isDark,
                      ),
                      _buildMenuCard(
                        'Lokasi',
                        PhosphorIconsFill.mapPin,
                        Colors.red,
                        '/lokasi',
                        isDark,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // 4. SECTION INFORMASI/KUTIPAN
                  _buildQuoteSection(isDark),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  // WIDGET: Kartu Sholat Berikutnya
  Widget _buildNextPrayerCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Nama kota di atas
          Row(
            children: [
              Icon(PhosphorIconsFill.mapPin, size: 16, color: primaryColor),
              const SizedBox(width: 8),
              Text(
                _selectedCity,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Main content
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(PhosphorIconsFill.info, size: 16, color: primaryColor),
                        const SizedBox(width: 8),
                        const Text('Sholat Berikutnya', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _nextPrayerName,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor),
                    ),
                    Text(
                      '$_nextPrayerTime WIB',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text('Sisa Waktu', style: TextStyle(fontSize: 10, color: primaryColor)),
                    Text(
                      _countdownTime,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // WIDGET: Kartu Menu Grid
  Widget _buildMenuCard(String title, IconData icon, Color color, String route, bool isDark) {
    return InkWell(
      onTap: () => Get.toNamed(route),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET: Section Kutipan/Quote
  Widget _buildQuoteSection(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor.withOpacity(0.8), primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Icon(PhosphorIconsFill.quotes, color: Colors.white, size: 32),
          const SizedBox(height: 12),
          const Text(
            '"Sebaik-baik manusia adalah yang paling bermanfaat bagi orang lain."',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '(HR. Ahmad)',
            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
          ),
        ],
      ),
    );
  }
}