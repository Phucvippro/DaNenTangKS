import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/attendance_record_model.dart';
import '../models/salary_info_model.dart';
import '../../../../core/errors/exceptions.dart';

abstract class ScheduleRemoteDataSource {
  /// Calls the api/attendance endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<AttendanceRecordModel>> getAttendanceRecords(DateTime startDate, DateTime endDate);

  /// Calls the api/salary endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<SalaryInfoModel>> getSalaryInfo(int year);

  /// Adds a new attendance record
  ///
  /// Throws a [ServerException] for all error codes.
  Future<void> addAttendanceRecord(AttendanceRecordModel record);

  /// Updates an existing attendance record
  ///
  /// Throws a [ServerException] for all error codes.
  Future<void> updateAttendanceRecord(AttendanceRecordModel record);
}

class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  ScheduleRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<List<AttendanceRecordModel>> getAttendanceRecords(DateTime startDate, DateTime endDate) async {
    final response = await client.get(
      Uri.parse('$baseUrl/api/attendance?startDate=${startDate.toIso8601String()}&endDate=${endDate.toIso8601String()}'),
      headers: {
        'Content-Type': 'application/json',
        // Add authorization header if needed
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => AttendanceRecordModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<SalaryInfoModel>> getSalaryInfo(int year) async {
    final response = await client.get(
      Uri.parse('$baseUrl/api/salary?year=$year'),
      headers: {
        'Content-Type': 'application/json',
        // Add authorization header if needed
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => SalaryInfoModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> addAttendanceRecord(AttendanceRecordModel record) async {
    final response = await client.post(
      Uri.parse('$baseUrl/api/attendance'),
      headers: {
        'Content-Type': 'application/json',
        // Add authorization header if needed
      },
      body: json.encode(record.toJson()),
    );

    if (response.statusCode != 201) {
      throw ServerException();
    }
  }

  @override
  Future<void> updateAttendanceRecord(AttendanceRecordModel record) async {
    final response = await client.put(
      Uri.parse('$baseUrl/api/attendance/${record.date.toIso8601String()}'),
      headers: {
        'Content-Type': 'application/json',
        // Add authorization header if needed
      },
      body: json.encode(record.toJson()),
    );

    if (response.statusCode != 200) {
      throw ServerException();
    }
  }
}