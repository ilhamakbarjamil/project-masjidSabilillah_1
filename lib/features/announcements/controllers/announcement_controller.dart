import 'package:flutter/material.dart';
import '../models/announcement_model.dart';
import '../repositories/announcement_repository.dart';

class AnnouncementController extends ChangeNotifier {
  final AnnouncementRepository _repository = AnnouncementRepository();

  List<AnnouncementModel> _announcements = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<AnnouncementModel> get announcements => _announcements;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load semua data
  Future<void> fetchAnnouncements() async {
    _setLoading(true);
    try {
      _announcements = await _repository.getAnnouncements();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// Tambah data
  Future<bool> addAnnouncement(String title, String content, bool isActive, String? ustadz) async {
    _setLoading(true);
    try {
      final newAnnouncement = AnnouncementModel(
        title: title,
        content: content,
        ustadz: ustadz, // Masukkan ke model
        date: DateTime.now(),
        isActive: isActive,
      );
      await _repository.createAnnouncement(newAnnouncement);
      await fetchAnnouncements(); 
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Update data
  Future<bool> editAnnouncement(String id, Map<String, dynamic> updates) async {
    _setLoading(true);
    try {
      await _repository.updateAnnouncement(id, updates);
      await fetchAnnouncements(); // Refresh list setelah update
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Hapus data
  Future<bool> deleteAnnouncement(String id) async {
    _setLoading(true);
    try {
      await _repository.deleteAnnouncement(id);
      await fetchAnnouncements(); // Refresh list setelah hapus
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}