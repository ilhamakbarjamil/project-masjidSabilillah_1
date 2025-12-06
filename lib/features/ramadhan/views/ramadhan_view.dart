import 'package:flutter/material.dart';
import '../models/ramadhan_model.dart';
import '../repositories/ramadhan_repository.dart';

class RamadhanView extends StatefulWidget {
  const RamadhanView({super.key});

  @override
  State<RamadhanView> createState() => _RamadhanViewState();
}

class _RamadhanViewState extends State<RamadhanView> {
  final RamadhanRepository _repo = RamadhanRepository();
  late Future<List<RamadhanScheduleModel>> _futureSchedules;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _futureSchedules = _repo.getSchedules();
    });
  }

  // Helper untuk format tanggal
  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  // --- LOGIKA FORM (CREATE & UPDATE JADI SATU) ---
  void _showFormDialog({RamadhanScheduleModel? itemToEdit}) {
    // Cek mode: Jika itemToEdit tidak null, berarti mode EDIT
    final isEditing = itemToEdit != null;

    // Inisialisasi Controller dengan data lama (jika edit) atau kosong (jika baru)
    final descController = TextEditingController(text: itemToEdit?.description ?? '');
    final personController = TextEditingController(text: itemToEdit?.personInCharge ?? '');
    final hijriController = TextEditingController(text: itemToEdit?.hijriDate?.toString() ?? '');
    
    String selectedType = itemToEdit?.activityType ?? 'Tarawih';
    DateTime selectedDate = itemToEdit?.activityDate ?? DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? "Edit Jadwal" : "Tambah Jadwal"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1. Pilih Tanggal
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text("Tanggal: ${_formatDate(selectedDate)}"),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2025),
                      lastDate: DateTime(2026),
                    );
                    if (picked != null) {
                      setDialogState(() => selectedDate = picked);
                    }
                  },
                ),
                
                // 2. Pilih Tipe Kegiatan
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(labelText: 'Jenis Kegiatan'),
                  items: const [
                    DropdownMenuItem(value: 'Tarawih', child: Text('Sholat Tarawih')),
                    DropdownMenuItem(value: 'Takjil', child: Text('Buka Puasa (Takjil)')),
                    DropdownMenuItem(value: 'Kajian', child: Text('Kajian/Ceramah')),
                  ],
                  onChanged: (val) => setDialogState(() => selectedType = val!),
                ),

                // 3. Input Ramadhan ke-berapa
                TextField(
                  controller: hijriController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Ramadhan ke- (Angka)"),
                ),

                // 4. Input Keterangan
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: "Keterangan", 
                    hintText: "Cth: Imam Ustadz Ali / Menu Ayam"
                  ),
                ),

                // 5. Input Penanggung Jawab
                TextField(
                  controller: personController,
                  decoration: const InputDecoration(labelText: "Petugas/Donatur (Opsional)"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: const Text("Batal")
            ),
            ElevatedButton(
              onPressed: () async {
                // Buat Object Model
                final data = RamadhanScheduleModel(
                  id: isEditing ? itemToEdit.id : null, // ID penting untuk edit
                  activityDate: selectedDate,
                  hijriDate: int.tryParse(hijriController.text),
                  activityType: selectedType,
                  description: descController.text,
                  personInCharge: personController.text,
                );

                try {
                  if (isEditing) {
                    await _repo.updateSchedule(data); // Panggil fungsi Update
                  } else {
                    await _repo.addSchedule(data); // Panggil fungsi Add
                  }
                  
                  if (context.mounted) Navigator.pop(context); // Tutup dialog
                  _refreshData(); // Refresh list
                  
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Gagal menyimpan: $e")),
                  );
                }
              },
              child: Text(isEditing ? "Update" : "Simpan"),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agenda Ramadhan 1446 H"),
        backgroundColor: const Color(0xFF0F2027),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () => _showFormDialog(), // Panggil tanpa parameter untuk mode Tambah
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<RamadhanScheduleModel>>(
          future: _futureSchedules,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.white)));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Belum ada jadwal", style: TextStyle(color: Colors.white70)));
            }

            final data = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                
                // Styling berdasarkan tipe
                IconData icon;
                Color color;
                if (item.activityType == 'Tarawih') {
                  icon = Icons.nights_stay;
                  color = Colors.indigo;
                } else if (item.activityType == 'Takjil') {
                  icon = Icons.fastfood;
                  color = Colors.orange;
                } else {
                  icon = Icons.mic;
                  color = Colors.teal;
                }

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color.withOpacity(0.1),
                      child: Icon(icon, color: color),
                    ),
                    title: Text(
                      item.activityType.toUpperCase(),
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          item.description, 
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
                        ),
                        if (item.personInCharge != null && item.personInCharge!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              "Oleh: ${item.personInCharge}", 
                              style: TextStyle(color: Colors.grey[600], fontSize: 13),
                            ),
                          ),
                      ],
                    ),
                    // Bagian Kanan (Tombol & Tanggal)
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (item.hijriDate != null)
                              Text("Ramadhan ${item.hijriDate}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            Text(
                              "${item.activityDate.day}/${item.activityDate.month}",
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        
                        // TOMBOL EDIT
                        InkWell(
                          onTap: () => _showFormDialog(itemToEdit: item), // Panggil dengan parameter untuk mode Edit
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(Icons.edit, size: 20, color: Colors.blue),
                          ),
                        ),
                        
                        // TOMBOL HAPUS
                        InkWell(
                          onTap: () async {
                             // Konfirmasi hapus sederhana
                             final confirm = await showDialog<bool>(
                               context: context,
                               builder: (ctx) => AlertDialog(
                                 title: const Text("Hapus?"),
                                 actions: [
                                   TextButton(onPressed: ()=> Navigator.pop(ctx, false), child: const Text("Batal")),
                                   TextButton(onPressed: ()=> Navigator.pop(ctx, true), child: const Text("Ya, Hapus", style: TextStyle(color: Colors.red))),
                                 ]
                               )
                             );
                             
                             if (confirm == true) {
                               await _repo.deleteSchedule(item.id!);
                               _refreshData();
                             }
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(Icons.delete, size: 20, color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}