import 'package:equatable/equatable.dart';
import '../../domain/entities/attendance_record.dart';
import '../../domain/entities/salary_info.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();
  
  @override
  List<Object?> get props => [];
}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class AttendanceRecordsLoaded extends ScheduleState {
  final List<AttendanceRecord> records;

  const AttendanceRecordsLoaded({required this.records});

  @override
  List<Object?> get props => [records];
}

class SalaryInfoLoaded extends ScheduleState {
  final List<SalaryInfo> salaryInfo;

  const SalaryInfoLoaded({required this.salaryInfo});

  @override
  List<Object?> get props => [salaryInfo];
}

class OperationSuccess extends ScheduleState {}

class OperationFailure extends ScheduleState {
  final String message;

  const OperationFailure({required this.message});

  @override
  List<Object?> get props => [message];
}