import 'package:dartz/dartz.dart';
import '../entities/attendance_record.dart';
import '../repositories/schedule_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:equatable/equatable.dart';

class GetAttendanceRecords implements UseCase<List<AttendanceRecord>, DateRangeParams> {
  final ScheduleRepository repository;

  GetAttendanceRecords(this.repository);

  @override
  Future<Either<Failure, List<AttendanceRecord>>> call(DateRangeParams params) async {
    return await repository.getAttendanceRecords(params.startDate, params.endDate);
  }
}

class DateRangeParams extends Equatable {
  final DateTime startDate;
  final DateTime endDate;

  const DateRangeParams({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}