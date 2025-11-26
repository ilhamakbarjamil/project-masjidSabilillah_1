import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  Future<void> saveCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('preferred_city', city);
  }

  Future<String> getCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('preferred_city') ?? 'Surabaya';
  }

  Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_theme', isDark);
  }

  Future<bool> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_dark_theme') ?? false;
  }
}