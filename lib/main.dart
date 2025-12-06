// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/services/supabase_service.dart';
import 'features/announcements/views/announcement_list_view.dart'; 
import 'core/views/onboarding_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    print("1. Mulai Load Environment...");
    await dotenv.load(fileName: ".env");
    
    // Cek apakah URL ada isinya
    final url = dotenv.env['SUPABASE_URL'];
    final key = dotenv.env['SUPABASE_ANON_KEY'];
    
    if (url == null || key == null) {
      throw Exception("URL atau KEY Supabase tidak ditemukan di file .env");
    }

    print("2. Inisialisasi Supabase...");
    await Supabase.initialize(
      url: url,
      anonKey: key,
    );
    print("3. Supabase Berhasil Diinisialisasi");

    // PENTING: Jalankan aplikasi HANYA jika inisialisasi sukses
    runApp(const MyApp());

  } catch (e) {
    print("ERROR FATAL: $e");
    // Jika error, jalankan aplikasi Error (Layar Merah/Pesan Error)
    runApp(ErrorApp(errorMessage: e.toString()));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase App',
      theme: ThemeData(primarySwatch: Colors.green),
      // fontFamily: 'Roboto',
      // Pastikan home mengarah ke View yang benar
      home: const OnboardingView(), 
    );
  }
}

// Widget sederhana untuk menampilkan error jika inisialisasi gagal
class ErrorApp extends StatelessWidget {
  final String errorMessage;
  const ErrorApp({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Gagal Memulai Aplikasi:\n$errorMessage",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}