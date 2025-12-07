class RamadhanScheduleModel {
  final String? id;
  final DateTime activityDate;
  final int? hijriDate; // Ramadhan ke-X
  final String activityType; // 'Tarawih', 'Takjil', 'Kajian'
  final String description;
  final String? personInCharge;

  RamadhanScheduleModel({
    this.id,
    required this.activityDate,
    this.hijriDate,
    required this.activityType,
    required this.description,
    this.personInCharge,
  });

  factory RamadhanScheduleModel.fromJson(Map<String, dynamic> json) {
    return RamadhanScheduleModel(
      id: json['id'],
      activityDate: DateTime.parse(json['activity_date']),
      hijriDate: json['hijri_date'],
      activityType: json['activity_type'],
      description: json['description'],
      personInCharge: json['person_in_charge'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'activity_date': activityDate.toIso8601String(),
      'hijri_date': hijriDate,
      'activity_type': activityType,
      'description': description,
      'person_in_charge': personInCharge,
    };
  }
}