// lib/features/announcements/views/announcement_form_view.dart

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/announcement_controller.dart';
import '../models/announcement_model.dart';

class AnnouncementFormView extends StatefulWidget {
  final AnnouncementController controller;
  final AnnouncementModel? announcementToEdit;

  const AnnouncementFormView({
    super.key,
    required this.controller,
    this.announcementToEdit,
  });

  @override
  State<AnnouncementFormView> createState() => _AnnouncementFormViewState();
}

class _AnnouncementFormViewState extends State<AnnouncementFormView> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _ustadzController; // Controller baru
  
  bool _isActive = true;
  String _type = 'Info'; // Default tipe: Info Umum

  bool get isEditing => widget.announcementToEdit != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.announcementToEdit?.title ?? '');
    _contentController = TextEditingController(text: widget.announcementToEdit?.content ?? '');
    _ustadzController = TextEditingController(text: widget.announcementToEdit?.ustadz ?? '');
    
    _isActive = widget.announcementToEdit?.isActive ?? true;

    // Logika otomatis mendeteksi tipe saat Edit
    if (isEditing && widget.announcementToEdit?.ustadz != null && widget.announcementToEdit!.ustadz!.isNotEmpty) {
      _type = 'Kajian';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _ustadzController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    // Logic: Jika tipe 'Info', ustadz dikosongkan (null)
    final String? ustadzValue = _type == 'Kajian' && _ustadzController.text.isNotEmpty 
        ? _ustadzController.text 
        : null;

    bool success;
    if (isEditing) {
      success = await widget.controller.editAnnouncement(
        widget.announcementToEdit!.id!,
        {
          'title': _titleController.text,
          'content': _contentController.text,
          'ustadz': ustadzValue,
          'isactive': _isActive,
          'updated_at': DateTime.now().toIso8601String(), // Wajib update ini
        },
      );
    } else {
      success = await widget.controller.addAnnouncement(
        _titleController.text,
        _contentController.text,
        _isActive,
        ustadzValue, // Kirim ke DB
      );
    }

    if (success && mounted) {
      Navigator.pop(context, true);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.controller.errorMessage ?? "Gagal menyimpan")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.grey[100], // Background sedikit abu supaya card menonjol
          appBar: AppBar(
            title: Text(isEditing ? 'Edit Informasi' : 'Buat Informasi Baru'),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SECTION 1: PILIH TIPE
                      _buildTypeSelector(),
                      
                      const SizedBox(height: 16),

                      // SECTION 2: FORM UTAMA
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _titleController,
                                decoration: const InputDecoration(
                                  labelText: 'Judul Informasi',
                                  hintText: 'Contoh: Kajian Subuh / Parkiran Penuh',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.title),
                                ),
                                validator: (val) => val!.isEmpty ? 'Judul wajib diisi' : null,
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // KOLOM USTADZ (Hanya muncul jika tipe Kajian)
                              if (_type == 'Kajian') ...[
                                TextFormField(
                                  controller: _ustadzController,
                                  decoration: const InputDecoration(
                                    labelText: 'Nama Ustadz',
                                    hintText: 'Contoh: Ustadz Khalid',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.person),
                                    fillColor: Color(0xFFF0FDF4), // Agak kehijauan
                                    filled: true,
                                  ),
                                  validator: (val) => _type == 'Kajian' && val!.isEmpty 
                                      ? 'Nama Ustadz wajib diisi untuk Kajian' 
                                      : null,
                                ),
                                const SizedBox(height: 16),
                              ],

                              TextFormField(
                                controller: _contentController,
                                maxLines: 4,
                                decoration: const InputDecoration(
                                  labelText: 'Detail Isi',
                                  border: OutlineInputBorder(),
                                  alignLabelWithHint: true,
                                  prefixIcon: Icon(Icons.description),
                                ),
                                validator: (val) => val!.isEmpty ? 'Konten wajib diisi' : null,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // SECTION 3: STATUS & TOMBOL
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: SwitchListTile(
                          title: const Text("Status Publikasi"),
                          subtitle: Text(_isActive ? "Ditampilkan di Aplikasi" : "Disembunyikan (Draft)"),
                          value: _isActive,
                          activeColor: AppColors.primary,
                          onChanged: (val) => setState(() => _isActive = val),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: widget.controller.isLoading ? null : _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(
                            isEditing ? 'UPDATE DATA' : 'SIMPAN DATA',
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              if (widget.controller.isLoading)
                Container(
                  color: Colors.black12,
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
      },
    );
  }

  // Widget Pilihan Tipe (Segmented-like buttons)
  Widget _buildTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _type = 'Info'),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: _type == 'Info' ? AppColors.primary : Colors.white,
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(10)),
                border: Border.all(color: AppColors.primary),
              ),
              child: Center(
                child: Text(
                  "Info Umum",
                  style: TextStyle(
                    color: _type == 'Info' ? Colors.white : AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _type = 'Kajian'),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: _type == 'Kajian' ? AppColors.primary : Colors.white,
                borderRadius: const BorderRadius.horizontal(right: Radius.circular(10)),
                border: Border.all(color: AppColors.primary),
              ),
              child: Center(
                child: Text(
                  "Kajian / Majelis",
                  style: TextStyle(
                    color: _type == 'Kajian' ? Colors.white : AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}