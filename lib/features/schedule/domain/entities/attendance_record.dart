import 'package:equatable/equatable.dart';

enum AttendanceStatus { present, late, absent }

class AttendanceRecord extends Equatable {
  final DateTime date;
  final AttendanceStatus status;
  final String note;

  const AttendanceRecord({
    required this.date, 
    required this.status, 
    this.note = ''
  });

  @override
  List<Object?> get props => [date, status, note];
}