// lib/main.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_sabilillah/core/constants/app_colors.dart';
import 'package:masjid_sabilillah/data/services/local_storage_service.dart';
import 'package:masjid_sabilillah/presentation/screens/home_screen.dart';
import 'package:masjid_sabilillah/presentation/screens/prayer_times_screen.dart';
import 'package:masjid_sabilillah/presentation/screens/settings_screen.dart';
// import 'package:masjid_sabilillah/presentation/screens/location_screen.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/jadwal',
      builder: (context, state) => const PrayerTimesScreen(),
    ),
    GoRoute(path: '/lokasi', builder: (context, state) => const LokasiScreen()),
    GoRoute(path: '/donasi', builder: (context, state) => const DonasiScreen()),
    GoRoute(
      path: '/pengumuman',
      builder: (context, state) => const PengumumanScreen(),
    ),
    GoRoute(
      path: '/pengaturan',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Error')),
    body: Center(child: Text('Route tidak ditemukan: ${state.uri}')),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: AppColors.lightPrimary,
        onPrimary: AppColors.lightTextOnPrimary,
        background: AppColors.lightBackground,
        surface: AppColors.lightSurface,
        onBackground: AppColors.lightTextPrimary,
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.lightTextOnPrimary,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: AppColors.darkPrimary,
        onPrimary: AppColors.lightTextOnPrimary,
        background: AppColors.darkBackground,
        surface: AppColors.darkSurface,
        onBackground: AppColors.darkTextPrimary,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.lightTextOnPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: LocalStorageService().getTheme(),
      builder: (context, snapshot) {
        final isDark = snapshot.data ?? false;

        return MaterialApp.router(
          routerConfig: _router,
          title: 'Masjid Sabilillah',
          debugShowCheckedModeBanner: false,
          theme: _buildLightTheme(),
          darkTheme: _buildDarkTheme(),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        );
      },
    );
  }
}

// Placeholder screens (hapus setelah buat aslinya)
class DonasiScreen extends StatelessWidget {
  const DonasiScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Donasi')),
    body: const Center(child: Text('Donasi')),
  );
}

class PengumumanScreen extends StatelessWidget {
  const PengumumanScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Pengumuman')),
    body: const Center(child: Text('Pengumuman')),
  );
}

class LokasiScreen extends StatelessWidget {
  const LokasiScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Lokasi Masjid')),
    body: const Center(child: Text('Lokasi')),
  );
}
