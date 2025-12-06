// lib/features/announcements/views/announcement_list_view.dart

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/announcement_controller.dart';
import 'announcement_detail_view.dart';
import 'announcement_form_view.dart';

// Pastikan file ini sudah dibuat sesuai langkah sebelumnya
// Jika error "Target of URI doesn't exist", cek folder features/ramadhan/views/
import '../../ramadhan/views/ramadhan_view.dart'; 

class AnnouncementListView extends StatefulWidget {
  const AnnouncementListView({super.key});

  @override
  State<AnnouncementListView> createState() => _AnnouncementListViewState();
}

class _AnnouncementListViewState extends State<AnnouncementListView> {
  final AnnouncementController _controller = AnnouncementController();

  // Tanggal perkiraan 1 Ramadhan 1446 H (1 Maret 2025)
  final DateTime _ramadanDate = DateTime(2025, 3, 1); 

  @override
  void initState() {
    super.initState();
    _controller.fetchAnnouncements();
  }

  // Helper: Format tanggal singkat
  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  // Helper: Deteksi konten Ramadhan untuk styling beda
  bool _isRamadanContent(String title, String content) {
    final t = title.toLowerCase();
    final c = content.toLowerCase();
    return t.contains('ramadhan') || t.contains('tarawih') || t.contains('buka') || 
           t.contains('sahur') || t.contains('zakat') || t.contains('fitrah');
  }

  // Widget: Header Countdown Ramadhan
  Widget _buildRamadanHeader() {
    final now = DateTime.now();
    final difference = _ramadanDate.difference(now).inDays;
    
    String titleText;
    String subText;

    if (difference > 0) {
      titleText = "$difference Hari Lagi";
      subText = "Menuju Bulan Suci Ramadhan 1446 H";
    } else if (difference > -30) {
      titleText = "Ramadhan Kareem";
      subText = "Selamat Menunaikan Ibadah Puasa";
    } else {
      return const SizedBox.shrink(); // Sembunyikan jika sudah lewat
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.nights_stay, color: Colors.amber, size: 32),
          const SizedBox(height: 8),
          Text(
            titleText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subText,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Informasi Masjid'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        actions: [
          // --- TOMBOL MENUJU DATABASE RAMADHAN (BARU) ---
          IconButton(
            tooltip: "Agenda Ramadhan",
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: () {
              // Navigasi ke halaman RamadhanView
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RamadhanView()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.edit_note),
        label: const Text("Buat Info"),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AnnouncementFormView(controller: _controller),
            ),
          );
          if (result == true) {
            _controller.fetchAnnouncements();
          }
        },
      ),
      body: Column(
        children: [
          // 1. Header Countdown Ramadhan
          _buildRamadanHeader(),

          // 2. List Data Utama
          Expanded(
            child: ListenableBuilder(
              listenable: _controller,
              builder: (context, child) {
                if (_controller.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (_controller.errorMessage != null) {
                  return Center(child: Text("Error: ${_controller.errorMessage}"));
                }

                if (_controller.announcements.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.mosque, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text("Belum ada informasi masjid", style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => _controller.fetchAnnouncements(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _controller.announcements.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = _controller.announcements[index];
                      
                      // Cek logika tampilan (Ramadhan vs Biasa)
                      final isRamadan = _isRamadanContent(item.title, item.content);

                      return Card(
                        elevation: isRamadan ? 4 : 1,
                        // Styling Border Emas jika Ramadhan
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: isRamadan 
                            ? const BorderSide(color: Colors.amber, width: 1.5)
                            : BorderSide.none,
                        ),
                        // Styling Background sedikit krem jika Ramadhan
                        color: isRamadan ? const Color(0xFFFFFDF5) : Colors.white,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            // Ke halaman detail
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AnnouncementDetailView(
                                  announcement: item,
                                  controller: _controller,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          // Icon Bintang jika Ramadhan
                                          if (isRamadan)
                                            const Padding(
                                              padding: EdgeInsets.only(right: 8.0),
                                              child: Icon(Icons.star, color: Colors.amber, size: 20),
                                            ),
                                          Expanded(
                                            child: Text(
                                              item.title,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: isRamadan ? Colors.brown[800] : Colors.black87,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      _formatDate(item.date),
                                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 8),

                                // Tampilkan Nama Ustadz jika ada
                                if (item.ustadz != null && item.ustadz!.isNotEmpty)
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 6),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.mic, size: 14, color: AppColors.primary),
                                        const SizedBox(width: 4),
                                        Text(
                                          item.ustadz!,
                                          style: const TextStyle(
                                              fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                                        ),
                                      ],
                                    ),
                                  ),

                                // Isi Konten
                                Text(
                                  item.content,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}