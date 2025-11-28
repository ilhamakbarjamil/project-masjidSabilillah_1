// lib/main.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:masjid_sabilillah/core/constants/app_colors.dart';
import 'package:masjid_sabilillah/core/providers/theme_provider.dart';
import 'package:masjid_sabilillah/presentation/screens/splash_screen.dart';
import 'package:masjid_sabilillah/presentation/screens/login_screen.dart';
import 'package:masjid_sabilillah/presentation/screens/signup_screen.dart';
import 'package:masjid_sabilillah/presentation/screens/home_screen.dart';
import 'package:masjid_sabilillah/presentation/screens/prayer_times_screen.dart';
import 'package:masjid_sabilillah/presentation/screens/location_screen.dart';
// import 'package:masjid_sabilillah/presentation/screens/donasi_screen.dart';
// import 'package:masjid_sabilillah/presentation/screens/pengumuman_screen.dart';
import 'package:masjid_sabilillah/presentation/screens/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

final GoRouter _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/jadwal',
      builder: (context, state) => const PrayerTimesScreen(),
    ),
    GoRoute(path: '/lokasi', builder: (context, state) => const LocationScreen()),
    // GoRoute(path: '/donasi', builder: (context, state) => const DonasiScreen()),
    // GoRoute(path: '/pengumuman', builder: (context, state) => const PengumumanScreen()),
    GoRoute(
      path: '/pengaturan',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        if (!themeProvider.isInitialized) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return MaterialApp.router(
          routerConfig: _router,
          title: 'Masjid Sabilillah',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.lightPrimary),
          ),
          darkTheme: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(primary: AppColors.darkPrimary),
          ),
          themeMode: themeProvider.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,
        );
      },
    );
  }
}
