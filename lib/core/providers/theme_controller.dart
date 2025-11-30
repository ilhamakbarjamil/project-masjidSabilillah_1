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
    isDarkMode.value = await _storageService.getTheme();
    isInitialized.value = true;
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
