import 'package:app/core/errors/failures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_attendance_records.dart';
import '../../domain/usecases/get_salary_info.dart';
import '../../domain/repositories/schedule_repository.dart';
import './schedule_event.dart';
import './schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final GetAttendanceRecords getAttendanceRecords;
  final GetSalaryInfo getSalaryInfo;
  final ScheduleRepository repository;

  ScheduleBloc({
    required this.getAttendanceRecords,
    required this.getSalaryInfo,
    required this.repository,
  }) : super(ScheduleInitial()) {
    on<GetAttendanceRecordsEvent>(_onGetAttendanceRecords);
    on<GetSalaryInfoEvent>(_onGetSalaryInfo);
    on<AddAttendanceRecordEvent>(_onAddAttendanceRecord);
    on<UpdateAttendanceRecordEvent>(_onUpdateAttendanceRecord);
  }

  Future<void> _onGetAttendanceRecords(
    GetAttendanceRecordsEvent event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleLoading());
    final result = await getAttendanceRecords(
      DateRangeParams(
        startDate: event.startDate,
        endDate: event.endDate,
      ),
    );

    emit(result.fold(
      (failure) => OperationFailure(message: _mapFailureToMessage(failure)),
      (records) => AttendanceRecordsLoaded(records: records),
    ));
  }

  Future<void> _onGetSalaryInfo(
    GetSalaryInfoEvent event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleLoading());
    final result = await getSalaryInfo(YearParams(year: event.year));

    emit(result.fold(
      (failure) => OperationFailure(message: _mapFailureToMessage(failure)),
      (salaryInfo) => SalaryInfoLoaded(salaryInfo: salaryInfo),
    ));
  }

  Future<void> _onAddAttendanceRecord(
    AddAttendanceRecordEvent event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleLoading());
    final result = await repository.addAttendanceRecord(event.record);

    emit(result.fold(
      (failure) => OperationFailure(message: _mapFailureToMessage(failure)),
      (_) => OperationSuccess(),
    ));
  }

  Future<void> _onUpdateAttendanceRecord(
    UpdateAttendanceRecordEvent event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleLoading());
    final result = await repository.updateAttendanceRecord(event.record);

    emit(result.fold(
      (failure) => OperationFailure(message: _mapFailureToMessage(failure)),
      (_) => OperationSuccess(),
    ));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Có lỗi từ máy chủ';
      case CacheFailure:
        return 'Không có dữ liệu đã lưu';
      case NetworkFailure:
        return 'Không có kết nối mạng';
      default:
        return 'Đã xảy ra lỗi không xác định';
    }
  }
}