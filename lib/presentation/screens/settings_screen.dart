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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section: Tampilan
            const Text(
              'Tampilan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primaryColor.withOpacity(0.3)),
              ),
              child: Obx(() => SwitchListTile(
                title: const Text('Tema Gelap'),
                value: themeController.isDarkMode.value,
                activeColor: primaryColor,
                onChanged: (bool value) {
                  themeController.toggleTheme(value);
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              )),
            ),
            const SizedBox(height: 32),
            // Section: Token FCM (untuk debugging)
            const Text('Info Perangkat', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primaryColor.withOpacity(0.25)),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Token FCM:', style: TextStyle(fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 18),
                        tooltip: 'Salin token',
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: _fcmToken));
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Token disalin!')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SelectableText(_fcmToken, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Section: Akun
            const Text('Akun', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primaryColor.withOpacity(0.3)),
              ),
              child: ListTile(
                title: const Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.logout, color: Colors.red, size: 24),
                ),
                onTap: () => _showLogoutDialog(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            const SizedBox(height: 16),
            // Tombol Tes Notifikasi Lokal
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.notifications_active),
                label: const Text('Tes Notifikasi Lokal'),
                onPressed: () {
                  NotificationService.showNotification(
                    RemoteMessage(
                      notification: RemoteNotification(
                        title: 'Notifikasi Masjid',
                        body: 'Ini adalah notifikasi lokal test (bukan FCM)',
                      ),
                      data: {},
                    ),
                  );
                },
              ),
            ),
            const Spacer(),
            // TOMBOL KEMBALI KE HOME
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [primaryColor.withOpacity(0.8), primaryColor], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () => Get.offAllNamed('/'),
                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.white, size: 24,),
                    const SizedBox(width: 8),
                    Text('Kembali ke Home', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    Get.defaultDialog(
      title: 'Konfirmasi Logout',
      middleText: 'Apakah Anda yakin ingin keluar dari akun?',
      textCancel: 'Batal',
      textConfirm: 'Logout',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        _logout();
      },
      cancelTextColor: Colors.blue,
      onCancel: () {},
    );
  }
}