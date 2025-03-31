import 'package:equatable/equatable.dart';
import '../../domain/entities/attendance_record.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object?> get props => [];
}

class GetAttendanceRecordsEvent extends ScheduleEvent {
  final DateTime startDate;
  final DateTime endDate;

  const GetAttendanceRecordsEvent({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

class GetSalaryInfoEvent extends ScheduleEvent {
  final int year;

  const GetSalaryInfoEvent({required this.year});

  @override
  List<Object?> get props => [year];
}

class AddAttendanceRecordEvent extends ScheduleEvent {
  final AttendanceRecord record;

  const AddAttendanceRecordEvent({required this.record});

  @override
  List<Object?> get props => [record];
}

class UpdateAttendanceRecordEvent extends ScheduleEvent {
  final AttendanceRecord record;

  const UpdateAttendanceRecordEvent({required this.record});

  @override
  List<Object?> get props => [record];
}