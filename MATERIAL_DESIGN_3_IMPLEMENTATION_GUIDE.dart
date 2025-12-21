// CONTOH UPDATE main.dart untuk Material Design 3 (GUNAKAN SEBAGAI REFERENSI)
// Salin bagian yang relevan ke file main.dart Anda

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_sabilillah/presentation/screens/splash_screen.dart';
import 'package:masjid_sabilillah/presentation/screens/login_screen.dart';
import 'package:masjid_sabilillah/presentation/screens/signup_screen.dart';
import 'package:masjid_sabilillah/presentation/screens/home_screen.dart';
import 'package:masjid_sabilillah/presentation/screens/prayer_times_screen.dart';
import 'package:masjid_sabilillah/presentation/screens/settings_screen.dart';
import 'package:masjid_sabilillah/lokasi/views/home_view.dart';
import 'package:masjid_sabilillah/core/providers/theme_controller.dart';
import 'package:masjid_sabilillah/core/constants/app_colors.dart';
import 'package:masjid_sabilillah/core/constants/app_text_theme.dart'; // NEW
import 'package:masjid_sabilillah/database/features/announcements/views/announcement_list_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:masjid_sabilillah/data/services/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('❌ Firebase init error: $e');
  }

  try {
    await NotificationService.init();
    NotificationService.listenToFirebase();
  } catch (e) {
    print('❌ NotificationService error: $e');
  }

  try {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  } catch (e) {
    print('⚠️ Permission request error: $e');
  }

  Get.put(ThemeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<ThemeController>(
      builder: (themeController) {
        if (!themeController.isInitialized.value) {
          Future.delayed(const Duration(seconds: 5), () {
            if (!themeController.isInitialized.value) {
              themeController.isInitialized.value = true;
            }
          });

          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Memuat aplikasi...'),
                ],
              ),
            ),
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
            GetPage(name: '/pengumuman', page: () => const AnnouncementListView()),
          ],
          initialRoute: '/splash',
          title: 'Masjid Sabilillah',
          debugShowCheckedModeBanner: false,
          
          // ====== MATERIAL DESIGN 3 CONFIGURATION ======
          // 1. LIGHT THEME - Material Design 3
          theme: ThemeData(
            useMaterial3: true, // ENABLE MATERIAL 3
            brightness: Brightness.light,
            
            // Color Scheme dengan dynamic colors
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.lightPrimary, // #0D3B66
              brightness: Brightness.light,
            ),
            
            // Typography Theme
            textTheme: AppTextTheme.lightTextTheme,
            
            // AppBar Theme
            appBarTheme: AppBarTheme(
              centerTitle: true,
              elevation: 0,
              backgroundColor: AppColors.lightPrimary,
              foregroundColor: Colors.white,
              titleTextStyle: AppTextTheme.lightTextTheme.titleLarge?.copyWith(
                color: Colors.white,
              ),
            ),
            
            // Card Theme
            cardTheme: CardTheme(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white,
            ),
            
            // Button Themes
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                textStyle: AppTextTheme.lightTextTheme.labelLarge,
              ),
            ),
            
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.lightPrimary,
                textStyle: AppTextTheme.lightTextTheme.labelMedium,
              ),
            ),
            
            // Input Decoration Theme
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.lightPrimary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              labelStyle: AppTextTheme.lightTextTheme.bodyMedium,
              hintStyle: AppTextTheme.lightTextTheme.bodySmall,
            ),
          ),
          
          // 2. DARK THEME - Material Design 3
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.darkPrimary, // #4A90E2
              brightness: Brightness.dark,
            ),
            
            textTheme: AppTextTheme.darkTextTheme,
            
            appBarTheme: AppBarTheme(
              centerTitle: true,
              elevation: 0,
              backgroundColor: const Color(0xFF121212),
              foregroundColor: Colors.white,
              titleTextStyle: AppTextTheme.darkTextTheme.titleLarge?.copyWith(
                color: Colors.white,
              ),
            ),
            
            cardTheme: CardTheme(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: const Color(0xFF1E1E1E),
            ),
            
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                textStyle: AppTextTheme.darkTextTheme.labelLarge,
              ),
            ),
            
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.darkPrimary,
                textStyle: AppTextTheme.darkTextTheme.labelMedium,
              ),
            ),
            
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.grey[800],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[700]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.darkPrimary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              labelStyle: AppTextTheme.darkTextTheme.bodyMedium,
              hintStyle: AppTextTheme.darkTextTheme.bodySmall,
            ),
          ),
          
          // 3. THEME MODE - Auto switch berdasarkan system
          themeMode: themeController.isDarkMode.value 
            ? ThemeMode.dark 
            : ThemeMode.light,
        );
      },
    );
  }
}
