// lib/presentation/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:masjid_sabilillah/core/providers/theme_controller.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:masjid_sabilillah/data/services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _fcmToken = '-';

  @override
  void initState() {
    super.initState();
    _initFcmToken();
  }

  Future<void> _initFcmToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      setState(() {
        _fcmToken = token ?? '-';
      });
    } catch (e) {
      setState(() {
        _fcmToken = 'Gagal mengambil token';
      });
    }
  }

  Future<void> _logout() async {
    try {
      await Supabase.instance.client.auth.signOut();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Logout Error', 'Gagal logout: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final themeController = Get.find<ThemeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        centerTitle: true,
        elevation: 0,
      ),
      // Perbaikan: Menggunakan SingleChildScrollView untuk menghindari overflow
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section: Tampilan
              _buildSectionTitle('Tampilan'),
              const SizedBox(height: 12),
              _buildSettingCard(
                child: Obx(() => SwitchListTile(
                      title: const Text('Tema Gelap', style: TextStyle(fontWeight: FontWeight.w500)),
                      value: themeController.isDarkMode.value,
                      activeColor: primaryColor,
                      onChanged: (bool value) {
                        themeController.toggleTheme(value);
                      },
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    )),
              ),

              const SizedBox(height: 24),

              // Section: Info Perangkat
              _buildSectionTitle('Info Perangkat'),
              const SizedBox(height: 12),
              _buildSettingCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Token FCM:', style: TextStyle(fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 20),
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                          tooltip: 'Salin token',
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: _fcmToken));
                            Get.snackbar(
                              'Berhasil', 
                              'Token FCM disalin ke clipboard!',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green.withOpacity(0.8),
                              colorText: Colors.white,
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      _fcmToken,
                      style: TextStyle(fontSize: 11, color: isDark ? Colors.grey[400] : Colors.grey[700], fontFamily: 'monospace'),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber.withOpacity(0.3)),
                      ),
                      child: const Text(
                        'Gunakan token ini untuk testing push notification di Firebase Console.',
                        style: TextStyle(fontSize: 12, color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Section: Akun & Aksi
              _buildSectionTitle('Akun & Aksi'),
              const SizedBox(height: 12),
              _buildSettingCard(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.notifications_active, color: Colors.blue),
                      title: const Text('Tes Notifikasi Lokal'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        NotificationService.showNotification(
                          RemoteMessage(
                            notification: RemoteNotification(
                              title: 'Notifikasi Masjid',
                              body: 'Ini adalah notifikasi lokal test (bukan FCM)',
                            ),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      onTap: () => _showLogoutDialog(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Tombol Kembali Ke Home
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () => Get.offAllNamed('/'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  icon: const Icon(Icons.home),
                  label: const Text('KEMBALI KE BERANDA', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                ),
              ),
              const SizedBox(height: 30), // Padding bawah agar tidak mepet
            ],
          ),
        ),
      ),
    );
  }

  // Widget Helper untuk Judul Section
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
    );
  }

  // Widget Helper untuk Card Container
  Widget _buildSettingCard({required Widget child, EdgeInsetsGeometry? padding}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: child,
      ),
    );
  }

  void _showLogoutDialog() {
    Get.defaultDialog(
      title: 'Konfirmasi Logout',
      titlePadding: const EdgeInsets.only(top: 20),
      contentPadding: const EdgeInsets.all(20),
      middleText: 'Apakah Anda yakin ingin keluar dari akun?',
      textCancel: 'Batal',
      textConfirm: 'Ya, Keluar',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        _logout();
      },
      cancelTextColor: Colors.grey,
    );
  }
}