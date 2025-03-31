import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../domain/entities/attendance_record.dart';

class AttendanceCalendar extends StatelessWidget {
  final Map<DateTime, AttendanceRecord> attendanceRecords;
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(CalendarFormat) onFormatChanged;
  final CalendarFormat calendarFormat;

  const AttendanceCalendar({
    Key? key,
    required this.attendanceRecords,
    required this.focusedDay,
    this.selectedDay,
    required this.onDaySelected,
    required this.onFormatChanged,
    required this.calendarFormat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar(
          firstDay: DateTime.utc(2024, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: focusedDay,
          calendarFormat: calendarFormat,
          selectedDayPredicate: (day) {
            return isSameDay(selectedDay, day);
          },
          onDaySelected: onDaySelected,
          onFormatChanged: onFormatChanged,
          calendarStyle: CalendarStyle(
            markersMaxCount: 1,
            weekendTextStyle: const TextStyle(color: Colors.red),
            markerDecoration: const BoxDecoration(
              color: Colors.transparent,
            ),
          ),
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, date, _) {
              return _buildCalendarDay(date, context);
            },
            selectedBuilder: (context, date, _) {
              return Container(
                margin: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: _buildCalendarDay(date, context),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarDay(DateTime date, BuildContext context) {
    final key = DateTime(date.year, date.month, date.day);
    final record = attendanceRecords[key];
    
    Color? backgroundColor;
    if (record != null) {
      switch (record.status) {
        case AttendanceStatus.present:
          backgroundColor = Colors.green;
          break;
        case AttendanceStatus.late:
          backgroundColor = Colors.orange;
          break;
        case AttendanceStatus.absent:
          backgroundColor = Colors.red;
          break;
      }
    }

    return Center(
      child: Container(
        margin: const EdgeInsets.all(4.0),
        decoration: backgroundColor != null ? BoxDecoration(
          color: backgroundColor.withOpacity(0.7),
          shape: BoxShape.circle,
        ) : null,
        child: Center(
          child: Text(
            '${date.day}',
            style: TextStyle(
              color: backgroundColor != null ? Colors.white : null,
            ),
          ),
        ),
      ),
    );
  }
}