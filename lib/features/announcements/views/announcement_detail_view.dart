// lib/features/announcements/views/announcement_detail_view.dart

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/announcement_controller.dart';
import '../models/announcement_model.dart';
import 'announcement_form_view.dart';

class AnnouncementDetailView extends StatelessWidget {
  final AnnouncementModel announcement;
  final AnnouncementController controller;

  const AnnouncementDetailView({
    super.key,
    required this.announcement,
    required this.controller,
  });

  // Helper untuk format tanggal
  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Detail Informasi"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // TOMBOL EDIT
          IconButton(
            tooltip: "Edit Data",
            icon: const Icon(Icons.edit),
            onPressed: () async {
              // Navigasi ke Form Edit
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnnouncementFormView(
                    controller: controller,
                    announcementToEdit: announcement,
                  ),
                ),
              );
              
              // Jika berhasil update, kembali ke list agar data ter-refresh
              if (result == true && context.mounted) {
                Navigator.pop(context); 
              }
            },
          ),
          // TOMBOL DELETE
          IconButton(
            tooltip: "Hapus Data",
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              _showDeleteConfirmation(context);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. JUDUL BESAR
            Text(
              announcement.title,
              style: const TextStyle(
                fontSize: 26, 
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            
            const SizedBox(height: 16),

            // 2. STATUS & TANGGAL (Baris Info)
            Row(
              children: [
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: announcement.isActive 
                        ? Colors.green.withOpacity(0.1) 
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: announcement.isActive ? Colors.green : Colors.red,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        announcement.isActive ? Icons.check_circle : Icons.cancel,
                        size: 16,
                        color: announcement.isActive ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        announcement.isActive ? "Aktif (Tayang)" : "Arsip (Non-Aktif)",
                        style: TextStyle(
                          color: announcement.isActive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const Spacer(),
                
                // Tanggal
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(announcement.date),
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 3. INFO USTADZ (Khusus Tipe Kajian)
            if (announcement.ustadz != null && announcement.ustadz!.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4), // Background kehijauan
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, color: AppColors.primary),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pemateri / Ustadz",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          announcement.ustadz!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            const Divider(thickness: 1, height: 1),
            const SizedBox(height: 24),

            // 4. KONTEN UTAMA
            const Text(
              "Detail Informasi:",
              style: TextStyle(
                fontSize: 14, 
                fontWeight: FontWeight.bold, 
                color: Colors.grey
              ),
            ),
            const SizedBox(height: 8),
            Text(
              announcement.content,
              style: const TextStyle(
                fontSize: 16, 
                height: 1.6, 
                color: Colors.black87
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog Konfirmasi Hapus
  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Informasi?"),
        content: const Text("Data yang dihapus tidak dapat dikembalikan lagi."),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (confirm == true && announcement.id != null) {
      // Tampilkan Loading Dialog
      if(context.mounted) {
        showDialog(
          context: context, 
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator())
        );
      }

      final success = await controller.deleteAnnouncement(announcement.id!);
      
      if(context.mounted) {
        // Tutup Loading
        Navigator.pop(context); 
        
        if (success) {
          Navigator.pop(context); // Kembali ke halaman List
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(controller.errorMessage ?? "Gagal menghapus")),
          );
        }
      }
    }
  }
}