// lib/presentation/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Perbaikan: Pastikan huruf 'j' ada pada masjid_sabilillah
import 'package:masjid_sabilillah/core/providers/theme_controller.dart'; 
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
// Perbaikan: Pastikan huruf 'j' ada pada masjid_sabilillah
import 'package:masjid_sabilillah/data/services/notification_service.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _fcmToken = '-';
  final primaryColor = const Color(0xFF00695C);

  @override
  void initState() {
    super.initState();
    _initFcmToken();
  }

  Future<void> _initFcmToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      setState(() => _fcmToken = token ?? '-');
    } catch (e) {
      setState(() => _fcmToken = 'Gagal mengambil token');
    }
  }

  Future<void> _logout() async {
    try {
      await Supabase.instance.client.auth.signOut();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Error', 'Gagal logout: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Memastikan ThemeController ditemukan
    final themeController = Get.find<ThemeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1716) : const Color(0xFFF5F7F7),
      appBar: AppBar(
        title: const Text('Pengaturan', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? Colors.white : primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Preferensi Tampilan'),
              _buildSettingCard(
                child: Obx(() => ListTile(
                  leading: Icon(
                    themeController.isDarkMode.value 
                        ? PhosphorIconsFill.moon 
                        : PhosphorIconsFill.sun,
                    color: primaryColor,
                  ),
                  title: const Text('Tema Gelap', style: TextStyle(fontWeight: FontWeight.w500)),
                  trailing: Switch.adaptive(
                    value: themeController.isDarkMode.value,
                    activeColor: primaryColor,
                    onChanged: (value) => themeController.toggleTheme(value),
                  ),
                )),
              ),

              const SizedBox(height: 24),

              _buildSectionHeader('Informasi Perangkat'),
              _buildSettingCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(PhosphorIconsFill.key, color: primaryColor, size: 20),
                        const SizedBox(width: 12),
                        const Text('Token FCM (Debug)', style: TextStyle(fontWeight: FontWeight.bold)),
                        const Spacer(),
                        IconButton(
                          icon: Icon(PhosphorIcons.copy(), size: 18, color: primaryColor),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: _fcmToken));
                            Get.rawSnackbar(
                              message: "Token berhasil disalin",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: primaryColor,
                              margin: const EdgeInsets.all(15),
                              borderRadius: 10,
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.black26 : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SelectableText(
                        _fcmToken,
                        style: TextStyle(
                          fontSize: 11, 
                          fontFamily: 'monospace',
                          color: isDark ? Colors.grey[400] : Colors.grey[700]
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              _buildSettingCard(
                child: ListTile(
                  leading: Icon(PhosphorIconsFill.bellRinging, color: Colors.blue[400]),
                  title: const Text('Tes Notifikasi Lokal'),
                  subtitle: const Text('Cek fungsi notifikasi di perangkat ini', style: TextStyle(fontSize: 12)),
                  trailing: const Icon(Icons.chevron_right, size: 20),
                  onTap: () {
                    NotificationService.showNotification(
                      RemoteMessage(
                        notification: RemoteNotification(
                          title: 'Tes Masjid Sabilillah',
                          body: 'Alhamdulillah, sistem notifikasi berfungsi dengan baik.',
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              _buildSectionHeader('Keamanan & Akun'),
              _buildSettingCard(
                child: ListTile(
                  leading: const Icon(PhosphorIconsFill.signOut, color: Colors.redAccent),
                  title: const Text('Keluar dari Akun', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600)),
                  onTap: () => _showLogoutDialog(),
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton.icon(
                  onPressed: () => Get.offAllNamed('/'),
                  icon: const Icon(PhosphorIconsFill.house, size: 20),
                  label: const Text('KEMBALI KE BERANDA', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12, 
          fontWeight: FontWeight.bold, 
          color: Colors.grey[500],
          letterSpacing: 1.2
        ),
      ),
    );
  }

  Widget _buildSettingCard({required Widget child, EdgeInsetsGeometry? padding}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: padding,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2625) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[200]!,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: child,
      ),
    );
  }

  void _showLogoutDialog() {
    Get.defaultDialog(
      title: 'Konfirmasi',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      middleText: 'Apakah Anda yakin ingin keluar dari aplikasi?',
      backgroundColor: Theme.of(context).canvasColor,
      radius: 20,
      contentPadding: const EdgeInsets.all(25),
      textCancel: 'Batal',
      textConfirm: 'Ya, Keluar',
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () {
        Get.back();
        _logout();
      },
      cancelTextColor: primaryColor,
    );
  }
}