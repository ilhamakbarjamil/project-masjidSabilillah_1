import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:masjid_sabilillah/data/services/local_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  final LocalStorageService _storageService = LocalStorageService();
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  bool get isLoggedIn => _isLoggedIn;

  AuthProvider() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Check if user has active session in Supabase
    final session = _supabaseClient.auth.currentSession;
    _isLoggedIn = session != null;
    notifyListeners();
  }

  Future<void> register(String email, String password, String fullName) async {
    try {
      // Register user dengan Supabase
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );

      if (response.user != null) {
        _isLoggedIn = true;
        await _storageService.saveLoginStatus(true);
        notifyListeners();
      } else {
        throw Exception('Registration failed');
      }
    } catch (e) {
      _isLoggedIn = false;
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      // Login dengan Supabase
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        _isLoggedIn = true;
        await _storageService.saveLoginStatus(true);
        notifyListeners();
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      _isLoggedIn = false;
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _supabaseClient.auth.signOut();
      _isLoggedIn = false;
      await _storageService.saveLoginStatus(false);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
