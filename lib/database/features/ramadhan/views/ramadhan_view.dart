import 'package:flutter/material.dart';
import '../../../core/services/supabase_service.dart'; // Import Service
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

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  void _showFormDialog({RamadhanScheduleModel? itemToEdit}) {
    final isEditing = itemToEdit != null;
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
                TextField(
                  controller: hijriController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Ramadhan ke- (Angka)"),
                ),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: "Keterangan", 
                    hintText: "Cth: Imam Ustadz Ali / Menu Ayam"
                  ),
                ),
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
                final data = RamadhanScheduleModel(
                  id: isEditing ? itemToEdit.id : null,
                  activityDate: selectedDate,
                  hijriDate: int.tryParse(hijriController.text),
                  activityType: selectedType,
                  description: descController.text,
                  personInCharge: personController.text,
                );

                try {
                  if (isEditing) {
                    await _repo.updateSchedule(data);
                  } else {
                    await _repo.addSchedule(data);
                  }
                  if (context.mounted) Navigator.pop(context);
                  _refreshData();
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
    // LOGIKA ADMIN
    final bool isAdmin = SupabaseService.isAdmin;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Agenda Ramadhan 1446 H"),
        backgroundColor: const Color(0xFF0F2027),
        foregroundColor: Colors.white,
      ),
      // HANYA TAMPILKAN FAB JIKA ADMIN
      floatingActionButton: isAdmin 
        ? FloatingActionButton(
            backgroundColor: Colors.amber,
            onPressed: () => _showFormDialog(),
            child: const Icon(Icons.add, color: Colors.black),
          )
        : null,
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
                    // HANYA TAMPILKAN TOMBOL EDIT/HAPUS JIKA ADMIN
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
                        
                        if (isAdmin) ...[
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () => _showFormDialog(itemToEdit: item),
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Icon(Icons.edit, size: 20, color: Colors.blue),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                               final confirm = await showDialog<bool>(
                                 context: context,
                                 builder: (ctx) => AlertDialog(
                                   title: const Text("Hapus?"),
                                   actions: [
                                     TextButton(onPressed: ()=> Navigator.pop(ctx, false), child: const Text("Batal")),
                                     TextButton(onPressed: ()=> Navigator.pop(ctx, true), child: const Text("Hapus", style: TextStyle(color: Colors.red))),
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
                        ]
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