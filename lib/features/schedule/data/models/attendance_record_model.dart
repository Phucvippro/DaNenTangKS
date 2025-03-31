import '../../domain/entities/attendance_record.dart';

class AttendanceRecordModel extends AttendanceRecord {
  const AttendanceRecordModel({
    required DateTime date,
    required AttendanceStatus status,
    String note = '',
  }) : super(
          date: date,
          status: status,
          note: note,
        );

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordModel(
      date: DateTime.parse(json['date']),
      status: AttendanceStatus.values.byName(json['status']),
      note: json['note'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'status': status.name,
      'note': note,
    };
  }

  factory AttendanceRecordModel.fromEntity(AttendanceRecord entity) {
    return AttendanceRecordModel(
      date: entity.date,
      status: entity.status,
      note: entity.note,
    );
  }
}