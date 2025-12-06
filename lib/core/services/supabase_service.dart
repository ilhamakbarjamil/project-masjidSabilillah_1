// lib/core/services/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  // Getter static untuk mengakses client
  static SupabaseClient get client => Supabase.instance.client;
  
  // Getter untuk mendapatkan user saat ini (berguna untuk RLS nanti)
  static User? get currentUser => client.auth.currentUser;
}