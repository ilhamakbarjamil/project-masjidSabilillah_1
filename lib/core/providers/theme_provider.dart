// lib/core/providers/theme_provider.dart
import 'package:flutter/foundation.dart';
import 'package:masjid_sabilillah/data/services/local_storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _isInitialized = false;
  final LocalStorageService _storageService = LocalStorageService();

  bool get isDarkMode => _isDarkMode;
  bool get isInitialized => _isInitialized;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    _isDarkMode = await _storageService.getTheme();
    _isInitialized = true;
    notifyListeners(); // Notifikasi setelah tema dimuat
  }

  // ✅ SOLUSI UTAMA: Update UI INSTAN, simpan di background
  void toggleTheme(bool isDark) {
    if (_isDarkMode == isDark) return;
    
    // 1. Update UI SEKETIKA
    _isDarkMode = isDark;
    notifyListeners();
    
    // 2. Simpan ke shared_preferences di BACKGROUND
    _saveThemeInBackground(isDark);
  }

  Future<void> _saveThemeInBackground(bool isDark) async {
    try {
      await _storageService.saveTheme(isDark);
    } catch (e) {
      // Jika gagal simpan, revert UI
      _isDarkMode = !_isDarkMode;
      notifyListeners();
      debugPrint('Gagal simpan tema: $e');
    }
  }
}