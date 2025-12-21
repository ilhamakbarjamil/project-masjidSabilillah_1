import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:masjid_sabilillah/data/services/local_storage_service.dart';

class ThemeController extends GetxController {
  var isDarkMode = false.obs;
  var isInitialized = false.obs;
  final LocalStorageService _storageService = LocalStorageService();

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      // Tambahkan timeout untuk mencegah stuck indefinitely
      final theme = await _storageService.getTheme().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          if (kDebugMode)
            print('⚠️ LocalStorage timeout, menggunakan default theme');
          return false;
        },
      );
      isDarkMode.value = theme;
    } catch (e) {
      if (kDebugMode) print('❌ Error loading theme: $e');
      isDarkMode.value = false; // Default ke light theme jika error
    } finally {
      isInitialized.value = true; // Pastikan always mark as initialized
    }
  }

  void toggleTheme(bool isDark) {
    if (isDarkMode.value == isDark) return;
    isDarkMode.value = isDark;
    _saveThemeInBackground(isDark);
  }

  Future<void> _saveThemeInBackground(bool isDark) async {
    try {
      await _storageService.saveTheme(isDark);
    } catch (e) {
      isDarkMode.value = !isDarkMode.value;
      Get.log('Gagal simpan tema: $e');
    }
  }
}
