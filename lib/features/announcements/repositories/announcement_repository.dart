// lib/features/announcements/repositories/announcement_repository.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/announcement_model.dart';

class AnnouncementRepository {
  SupabaseClient get _client => SupabaseService.client;
  final String _tableName = 'announcements';

  /// GET: Mengambil semua pengumuman
  Future<List<AnnouncementModel>> getAnnouncements() async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .order('date', ascending: false);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => AnnouncementModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Gagal mengambil data: $e');
    }
  }

  /// POST: Menambah pengumuman baru
  Future<void> createAnnouncement(AnnouncementModel announcement) async {
    try {
      await _client.from(_tableName).insert(announcement.toJson());
    } catch (e) {
      print("ERROR CREATE: $e"); // Debug print
      throw Exception('Gagal membuat pengumuman: $e');
    }
  }

  /// UPDATE: Mengupdate pengumuman
  Future<void> updateAnnouncement(String id, Map<String, dynamic> updates) async {
    try {
      print("Mencoba update ID: $id");
      print("Data update: $updates");

      // Kita gunakan .select() di akhir untuk memastikan data benar-benar terupdate
      final response = await _client
          .from(_tableName)
          .update(updates)
          .eq('id', id)
          .select(); // Penting: Supabase v2 butuh ini kadang untuk konfirmasi
      
      print("Berhasil update. Response: $response");
    } catch (e) {
      print("ERROR UPDATE: $e"); // Cek error di debug console
      throw Exception('Gagal update pengumuman: $e');
    }
  }

  /// DELETE: Menghapus pengumuman
  Future<void> deleteAnnouncement(String id) async {
    try {
      print("Mencoba delete ID: $id");
      await _client.from(_tableName).delete().eq('id', id);
      print("Berhasil delete");
    } catch (e) {
      print("ERROR DELETE: $e"); // Cek error di debug console
      throw Exception('Gagal menghapus pengumuman: $e');
    }
  }
}