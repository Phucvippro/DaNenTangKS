import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/attendance_record_model.dart';
import '../models/salary_info_model.dart';
import '../../../../core/errors/exceptions.dart';

abstract class ScheduleLocalDataSource {
  /// Gets the cached list of [AttendanceRecordModel].
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<List<AttendanceRecordModel>> getLastAttendanceRecords();

  /// Gets the cached list of [SalaryInfoModel].
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<List<SalaryInfoModel>> getLastSalaryInfo();

  Future<void> cacheAttendanceRecords(List<AttendanceRecordModel> records);

  Future<void> cacheSalaryInfo(List<SalaryInfoModel> salaryInfo);
}

const CACHED_ATTENDANCE_RECORDS = 'CACHED_ATTENDANCE_RECORDS';
const CACHED_SALARY_INFO = 'CACHED_SALARY_INFO';

class ScheduleLocalDataSourceImpl implements ScheduleLocalDataSource {
  final SharedPreferences sharedPreferences;

  ScheduleLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<AttendanceRecordModel>> getLastAttendanceRecords() {
    final jsonString = sharedPreferences.getString(CACHED_ATTENDANCE_RECORDS);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return Future.value(jsonList.map((json) => AttendanceRecordModel.fromJson(json)).toList());
    } else {
      throw CacheException();
    }
  }

  @override
  Future<List<SalaryInfoModel>> getLastSalaryInfo() {
    final jsonString = sharedPreferences.getString(CACHED_SALARY_INFO);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return Future.value(jsonList.map((json) => SalaryInfoModel.fromJson(json)).toList());
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheAttendanceRecords(List<AttendanceRecordModel> records) {
    final List<Map<String, dynamic>> jsonList = records.map((record) => record.toJson()).toList();
    return sharedPreferences.setString(
      CACHED_ATTENDANCE_RECORDS,
      json.encode(jsonList),
    );
  }

  @override
  Future<void> cacheSalaryInfo(List<SalaryInfoModel> salaryInfo) {
    final List<Map<String, dynamic>> jsonList = salaryInfo.map((info) => info.toJson()).toList();
    return sharedPreferences.setString(
      CACHED_SALARY_INFO,
      json.encode(jsonList),
    );
  }
}