// lib/presentation/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // 1. Load .env
      await dotenv.load(fileName: ".env");
      
      // 2. Ambil kredensial
      final supabaseUrl = dotenv.env['SUPABASE_URL'];
      final supabaseKey = dotenv.env['SUPABASE_ANON_KEY'];
      
      if (supabaseUrl == null || supabaseKey == null) {
        throw Exception('File .env tidak terisi dengan benar');
      }
      
      // 3. Initialize Supabase
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseKey,
      );
      
      // 4. Cek session
      final supabase = Supabase.instance.client;
      final session = supabase.auth.currentSession;
      
      // 5. Delay minimal 1 detik agar splash terlihat
      await Future.delayed(const Duration(seconds: 1));
      
      // ✅ Redirect ke HOME jika sudah login, ke LOGIN jika belum
      if (mounted) {
        Get.offAllNamed(session != null ? '/' : '/login');
      }
    } catch (e) {
      print('🔥 SPLASH ERROR: $e');
      
      // Fallback: redirect ke login
      if (mounted) {
        Get.offAllNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D3B66), Color(0xFF1E1E1E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.mosque, color: Color(0xFF0D3B66), size: 60),
              ),
              const SizedBox(height: 32),
              const Text(
                'Masjid Sabilillah',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              const CircularProgressIndicator(color: Colors.white),
              const SizedBox(height: 16),
              const Text(
                'Memuat aplikasi...',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}