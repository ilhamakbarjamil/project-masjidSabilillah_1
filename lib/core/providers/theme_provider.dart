import 'package:flutter/material.dart';
import 'package:masjid_sabilillah/data/services/local_storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  final LocalStorageService _storageService = LocalStorageService();

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    _isDarkMode = await _storageService.getTheme();
    notifyListeners();
  }

  Future<void> toggleTheme(bool isDark) async {
    _isDarkMode = isDark;
    await _storageService.saveTheme(isDark);
    notifyListeners();
  }
}
