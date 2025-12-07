// lib/core/services/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  // Getter static untuk mengakses client
  static SupabaseClient get client => Supabase.instance.client;
  
  // Getter untuk mendapatkan user saat ini (berguna untuk RLS nanti)
  static User? get currentUser => client.auth.currentUser;

  // LOGIKA ADMIN: Cek apakah email user yang login adalah email admin
  // Sesuaikan email ini dengan yang ada di SQL tadi
  static bool get isAdmin {
    final user = client.auth.currentUser;
    return user != null && user.email == 'admin@masjid.com';
  }
}