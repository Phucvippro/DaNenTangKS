import 'package:dartz/dartz.dart';
import '../../domain/entities/attendance_record.dart';
import '../../domain/entities/salary_info.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../datasources/schedule_remote_data_source.dart';
import '../datasources/schedule_local_data_source.dart';
import '../models/attendance_record_model.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource remoteDataSource;
  final ScheduleLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ScheduleRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<AttendanceRecord>>> getAttendanceRecords(
      DateTime startDate, DateTime endDate) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteRecords = await remoteDataSource.getAttendanceRecords(startDate, endDate);
        localDataSource.cacheAttendanceRecords(remoteRecords);
        return Right(remoteRecords);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localRecords = await localDataSource.getLastAttendanceRecords();
        return Right(localRecords);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<SalaryInfo>>> getSalaryInfo(int year) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteSalaryInfo = await remoteDataSource.getSalaryInfo(year);
        localDataSource.cacheSalaryInfo(remoteSalaryInfo);
        return Right(remoteSalaryInfo);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localSalaryInfo = await localDataSource.getLastSalaryInfo();
        return Right(localSalaryInfo);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, void>> addAttendanceRecord(AttendanceRecord record) async {
    if (await networkInfo.isConnected) {
      try {
        final recordModel = AttendanceRecordModel.fromEntity(record);
        await remoteDataSource.addAttendanceRecord(recordModel);
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateAttendanceRecord(AttendanceRecord record) async {
    if (await networkInfo.isConnected) {
      try {
        final recordModel = AttendanceRecordModel.fromEntity(record);
        await remoteDataSource.updateAttendanceRecord(recordModel);
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}