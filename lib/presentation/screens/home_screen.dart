// lib/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _userName;
  final primaryColor = const Color(0xFF00695C);
  final accentColor = const Color(0xFF004D40);

  @override
  void initState() {
    super.initState();
    _loadUserData();
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1716) : const Color(0xFFF5F7F7),
      body: CustomScrollView(
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(PhosphorIconsFill.info, size: 16, color: primaryColor),
                  const SizedBox(width: 8),
                  const Text('Sholat Berikutnya', style: TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Dzuhur',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor),
              ),
              const Text('11:45 WIB', style: TextStyle(fontSize: 16, color: Colors.grey)),
            ],
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
                const Text('-02:15:00', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
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