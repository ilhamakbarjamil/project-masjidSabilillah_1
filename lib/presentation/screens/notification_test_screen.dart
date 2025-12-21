import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_sabilillah/data/services/notification_service.dart';
import 'package:masjid_sabilillah/core/constants/app_colors.dart';

class NotificationTestScreen extends StatefulWidget {
  const NotificationTestScreen({super.key});

  @override
  State<NotificationTestScreen> createState() => _NotificationTestScreenState();
}

class _NotificationTestScreenState extends State<NotificationTestScreen> {
  final List<String> _prayerNames = ['Subuh', 'Dhuhur', 'Ashar', 'Maghrib', 'Isya'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.lightPrimary;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1716) : const Color(0xFFF5F7F7),
      appBar: AppBar(
        title: const Text('Test Notifikasi Sholat', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? Colors.white : primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryColor, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: primaryColor, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Testing Notifikasi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Gunakan tombol di bawah untuk test notifikasi sholat. '
                    'Notifikasi akan muncul seperti di waktu sholat yang sebenarnya.',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Test Single Notification
            Text(
              'Test Notifikasi Per Sholat',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // Prayer Buttons Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _prayerNames.length,
              itemBuilder: (context, index) {
                final prayerName = _prayerNames[index];
                return _buildTestButton(
                  label: prayerName,
                  icon: Icons.notifications_active,
                  onPressed: () => _testPrayerNotification(prayerName),
                  isDark: isDark,
                );
              },
            ),

            const SizedBox(height: 28),

            // Custom Message Section
            Text(
              'Test Notifikasi Custom',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // Custom Test Button
            _buildCustomTestButton(isDark),

            const SizedBox(height: 28),

            // Cancel All Section
            Text(
              'Kelola Notifikasi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _cancelAllNotifications,
                icon: const Icon(Icons.delete_sweep),
                label: const Text('Batalkan Semua Notifikasi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Info Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade300, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.help_outline, color: Colors.blue.shade600, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Tips Testing',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Notifikasi akan muncul secara real-time\n'
                    '• Pastikan notifikasi permission sudah diizinkan\n'
                    '• Jika tidak muncul, cek Android notification settings\n'
                    '• App bisa di-background untuk test notification\n'
                    '• Setiap prayer time dijadwalkan otomatis dari jadwal sholat',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade700,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTestButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required bool isDark,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
      ),
    );
  }

  Widget _buildCustomTestButton(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _testCustomNotification,
            icon: const Icon(Icons.message),
            label: const Text('Test Custom Notifikasi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Test notifikasi dengan pesan custom',
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _testPrayerNotification(String prayerName) {
    NotificationService.showTestNotification(
      title: '🕌 Waktunya Sholat $prayerName',
      body: 'Sudah masuk waktu sholat $prayerName. Yuk segera bersiap!',
      payload: 'prayer_$prayerName',
    ).then((_) {
      Get.snackbar(
        'Notifikasi Test',
        'Notifikasi sholat $prayerName berhasil ditampilkan!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    });
  }

  void _testCustomNotification() {
    NotificationService.showTestNotification(
      title: '✨ Notifikasi Custom MySabilillah',
      body: 'Ini adalah notifikasi test untuk testing sistem notifikasi aplikasi',
      payload: 'custom_test',
    ).then((_) {
      Get.snackbar(
        'Custom Test',
        'Custom notifikasi berhasil ditampilkan!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    });
  }

  void _cancelAllNotifications() {
    NotificationService.cancelAllNotifications().then((_) {
      Get.snackbar(
        'Dibatalkan',
        'Semua scheduled notifications sudah dibatalkan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    });
  }
}
