import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/constants/app_colors.dart';
import 'routes/app_pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Modul 5 - Location Aware',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: AppColors.lightPrimary,
        ),
      ),
      initialRoute: AppPages.INITIAL, // ✅ Mengarah ke /location
      getPages: AppPages.routes, // ✅ Sudah termasuk semua rute lokasi
    );
  }
}