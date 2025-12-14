// lib/main.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:masjid_sabilillah/core/constants/app_colors.dart';
import 'package:masjid_sabilillah/core/providers/theme_provider.dart';
import 'package:masjid_sabilillah/core/providers/auth_provider.dart';
import 'package:masjid_sabilillah/presentation/screens/home_screen.dart';
import 'package:masjid_sabilillah/presentation/screens/prayer_times_screen.dart';
import 'package:masjid_sabilillah/presentation/screens/settings_screen.dart';
import 'package:masjid_sabilillah/presentation/screens/login_screen.dart';
import 'package:masjid_sabilillah/presentation/screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('main: start initialization');

  // Load environment variables

  // Initialize Supabase
  // Do NOT perform long async initialization (dotenv / Supabase) here before runApp.
  // Move initialization into a provider (AuthProvider) so the first Flutter frame
  // can be rendered quickly and we can show a loading UI while services initialize.
  debugPrint('main: starting app (deferred Supabase/dotenv init to provider)');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

GoRouter _createRouter(bool isLoggedIn) {
  return GoRouter(
    initialLocation: isLoggedIn ? '/' : '/login',
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/jadwal',
        builder: (context, state) => const PrayerTimesScreen(),
      ),
      GoRoute(
        path: '/lokasi',
        builder: (context, state) => const LokasiScreen(),
      ),
      GoRoute(
        path: '/donasi',
        builder: (context, state) => const DonasiScreen(),
      ),
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
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Consumer2<ThemeProvider, AuthProvider>(
      builder: (context, themeProvider, authProvider, child) {
        final isInitializing =
            themeProvider.isInitializing || authProvider.isInitializing;

        if (isInitializing) {
          // Tampilkan loading sederhana selama provider inisialisasi
          return MaterialApp(
            title: 'Masjid Sabilillah',
            debugShowCheckedModeBanner: false,
            theme: _buildLightTheme(),
            darkTheme: _buildDarkTheme(),
            themeMode: themeProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            home: const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return MaterialApp.router(
          routerConfig: _createRouter(authProvider.isLoggedIn),
=======
    return GetX<ThemeController>(
      builder: (themeController) {
        if (!themeController.isInitialized.value) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return GetMaterialApp(
          getPages: [
            GetPage(name: '/splash', page: () => const SplashScreen()),
            GetPage(name: '/login', page: () => const LoginScreen()),
            GetPage(name: '/signup', page: () => const SignupScreen()),
            GetPage(name: '/', page: () => const HomeScreen()),
            GetPage(name: '/jadwal', page: () => const PrayerTimesScreen()),
            GetPage(name: '/pengaturan', page: () => const SettingsScreen()),
            GetPage(name: '/lokasi', page: () => const HomeView()),
            GetPage(
              name: '/pengumuman',
              page: () => const AnnouncementListView(),
            ),
          ],
          initialRoute: '/splash',
>>>>>>> fitur/notifikasi
          title: 'Masjid Sabilillah',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.lightPrimary),
          ),
          darkTheme: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(primary: AppColors.darkPrimary),
          ),
          themeMode: themeController.isDarkMode.value
              ? ThemeMode.dark
              : ThemeMode.light,
        );
      },
    );
  }
}
<<<<<<< HEAD

// Placeholder screens
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
=======
>>>>>>> fitur/notifikasi
