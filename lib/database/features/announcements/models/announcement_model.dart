// lib/features/announcements/models/announcement_model.dart

class AnnouncementModel {
  final String? id;
  final String title;
  final String content;
  final String? ustadz; // Tambahan: Nullable (bisa kosong)
  final DateTime date;
  final bool isActive;
  final DateTime? createdAt;

  AnnouncementModel({
    this.id,
    required this.title,
    required this.content,
    this.ustadz, // Tambahan
    required this.date,
    this.isActive = true,
    this.createdAt,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      // Tambahan: Ambil data ustadz
      ustadz: json['ustadz'] as String?,
      date: DateTime.parse(json['date'] as String).toLocal(),
      isActive: json['isactive'] ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String).toLocal() 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'content': content,
      'ustadz': ustadz, // Tambahan: Kirim ke database
      'date': date.toIso8601String(),
      'isactive': isActive,
    };
  }
}