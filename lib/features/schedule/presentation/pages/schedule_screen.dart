import 'package:app/features/schedule/presentation/widgets/attendance_celendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../bloc/schedule_bloc.dart';
import '../bloc/schedule_event.dart';
import '../bloc/schedule_state.dart';
import '../widgets/attendamce_summary.dart';
import '../widgets/attendance_celendar.dart';
import '../widgets/attendamce_summary.dart';
import '../widgets/salary_chart.dart';
import '../../domain/entities/attendance_record.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  int _selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedDay = _focusedDay;
    
    // Load data
    _loadAttendanceData();
    _loadSalaryData();
  }

  void _loadAttendanceData() {
    final startOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final endOfMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    
    context.read<ScheduleBloc>().add(GetAttendanceRecordsEvent(
      startDate: startOfMonth,
      endDate: endOfMonth,
    ));
  }

  void _loadSalaryData() {
    context.read<ScheduleBloc>().add(GetSalaryInfoEvent(year: _selectedYear));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch & Lương'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Điểm danh'),
            Tab(text: 'Lương'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAttendanceTab(),
          _buildSalaryTab(),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: () => _showAttendanceDialog(),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildAttendanceTab() {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        if (state is ScheduleLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AttendanceRecordsLoaded) {
          final records = state.records;
          final attendanceMap = {
            for (var record in records)
              DateTime(record.date.year, record.date.month, record.date.day): record
          };

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AttendanceCalendar(
                    attendanceRecords: attendanceMap,
                    focusedDay: _focusedDay,
                    selectedDay: _selectedDay,
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                      
                      // Show attendance details if exists
                      final key = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
                      if (attendanceMap.containsKey(key)) {
                        _showAttendanceDetails(attendanceMap[key]!);
                      } else {
                        _showAttendanceDialog(selectedDate: selectedDay);
                      }
                    },
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    calendarFormat: _calendarFormat,
                  ),
                  const SizedBox(height: 24),
                  AttendanceSummary(
                    records: records,
                    focusedMonth: _focusedDay,
                  ),
                ],
              ),
            ),
          );
        } else if (state is OperationFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadAttendanceData,
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Chưa có dữ liệu'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadAttendanceData,
                  child: const Text('Tải dữ liệu'),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildSalaryTab() {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        if (state is ScheduleLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SalaryInfoLoaded) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Text('Chọn năm:'),
                      const SizedBox(width: 16),
                      DropdownButton<int>(
                        value: _selectedYear,
                        items: List.generate(5, (index) {
                          final year = DateTime.now().year - 2 + index;
                          return DropdownMenuItem(
                            value: year,
                            child: Text('$year'),
                          );
                        }),
                        onChanged: (value) {
                          if (value != null && value != _selectedYear) {
                            setState(() {
                              _selectedYear = value;
                            });
                            context.read<ScheduleBloc>().add(
                              GetSalaryInfoEvent(year: value),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SalaryChart(
                  salaryData: state.salaryInfo,
                  selectedYear: _selectedYear,
                ),
              ],
            ),
          );
        } else if (state is OperationFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadSalaryData,
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Chưa có dữ liệu lương'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadSalaryData,
                  child: const Text('Tải dữ liệu'),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  void _showAttendanceDialog({DateTime? selectedDate}) {
    final date = selectedDate ?? _selectedDay ?? DateTime.now();
    AttendanceStatus selectedStatus = AttendanceStatus.present;
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Điểm danh ${DateFormat('dd/MM/yyyy').format(date)}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<AttendanceStatus>(
              value: selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Trạng thái',
              ),
              items: const [
                DropdownMenuItem(
                  value: AttendanceStatus.present,
                  child: Text('Đầy đủ'),
                ),
                DropdownMenuItem(
                  value: AttendanceStatus.late,
                  child: Text('Đi muộn'),
                ),
                DropdownMenuItem(
                  value: AttendanceStatus.absent,
                  child: Text('Vắng mặt'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  selectedStatus = value;
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: 'Ghi chú',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              final record = AttendanceRecord(
                date: date,
                status: selectedStatus,
                note: noteController.text,
              );
              
              context.read<ScheduleBloc>().add(
                AddAttendanceRecordEvent(record: record),
              );
              
              Navigator.of(context).pop();
              
              // Reload data after adding
              Future.delayed(const Duration(milliseconds: 500), _loadAttendanceData);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _showAttendanceDetails(AttendanceRecord record) {
    final noteController = TextEditingController(text: record.note);
    AttendanceStatus selectedStatus = record.status;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chi tiết ${DateFormat('dd/MM/yyyy').format(record.date)}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<AttendanceStatus>(
              value: selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Trạng thái',
              ),
              items: const [
                DropdownMenuItem(
                  value: AttendanceStatus.present,
                  child: Text('Đầy đủ'),
                ),
                DropdownMenuItem(
                  value: AttendanceStatus.late,
                  child: Text('Đi muộn'),
                ),
                DropdownMenuItem(
                  value: AttendanceStatus.absent,
                  child: Text('Vắng mặt'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  selectedStatus = value;
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: 'Ghi chú',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedRecord = AttendanceRecord(
                date: record.date,
                status: selectedStatus,
                note: noteController.text,
              );
              
              context.read<ScheduleBloc>().add(
                UpdateAttendanceRecordEvent(record: updatedRecord),
              );
              
              Navigator.of(context).pop();
              
              // Reload data after updating
              Future.delayed(const Duration(milliseconds: 500), _loadAttendanceData);
            },
            child: const Text('Cập nhật'),
          ),
        ],
      ),
    );
  }
}