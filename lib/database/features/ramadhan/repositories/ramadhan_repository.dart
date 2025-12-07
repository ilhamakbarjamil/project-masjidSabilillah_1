import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';
import '../models/ramadhan_model.dart';

class RamadhanRepository {
  SupabaseClient get _client => SupabaseService.client;
  final String _tableName = 'ramadhan_schedules';

  // GET: Ambil jadwal, urutkan dari tanggal terdekat
  Future<List<RamadhanScheduleModel>> getSchedules() async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .order('activity_date', ascending: true); // Urutkan tanggal

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => RamadhanScheduleModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Gagal ambil jadwal Ramadhan: $e');
    }
  }

  // POST: Tambah Jadwal
  Future<void> addSchedule(RamadhanScheduleModel data) async {
    try {
      await _client.from(_tableName).insert(data.toJson());
    } catch (e) {
      throw Exception('Gagal tambah jadwal: $e');
    }
  }
  
  // DELETE: Hapus Jadwal
  Future<void> deleteSchedule(String id) async {
    await _client.from(_tableName).delete().eq('id', id);
  }

  // UPDATE: Mengupdate Jadwal yang ada
  Future<void> updateSchedule(RamadhanScheduleModel data) async {
    if (data.id == null) return; // ID wajib ada untuk update
    
    try {
      // Kita hapus ID dari map update agar tidak menimpa Primary Key (opsional tapi aman)
      final updateData = data.toJson();
      updateData.remove('id'); 

      await _client
          .from(_tableName)
          .update(updateData)
          .eq('id', data.id!); // Cari baris berdasarkan ID
    } catch (e) {
      throw Exception('Gagal update jadwal: $e');
    }
  }
}