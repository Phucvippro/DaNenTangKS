import 'package:dartz/dartz.dart';
import '../entities/attendance_record.dart';
import '../entities/salary_info.dart';
import '../../../../core/errors/failures.dart';

abstract class ScheduleRepository {
  Future<Either<Failure, List<AttendanceRecord>>> getAttendanceRecords(DateTime startDate, DateTime endDate);
  Future<Either<Failure, List<SalaryInfo>>> getSalaryInfo(int year);
  Future<Either<Failure, void>> addAttendanceRecord(AttendanceRecord record);
  Future<Either<Failure, void>> updateAttendanceRecord(AttendanceRecord record);
}