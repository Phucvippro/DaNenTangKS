import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/attendance_record.dart';

class AttendanceSummary extends StatelessWidget {
  final List<AttendanceRecord> records;
  final DateTime focusedMonth;

  const AttendanceSummary({
    Key? key,
    required this.records,
    required this.focusedMonth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tính số ngày đi làm đầy đủ, muộn và vắng
    int present = 0, late = 0, absent = 0;

    // Chỉ tính cho tháng hiện tại
    final currentMonth = focusedMonth.month;
    final currentYear = focusedMonth.year;
    
    for (var record in records) {
      if (record.date.month == currentMonth && record.date.year == currentYear) {
        switch (record.status) {
          case AttendanceStatus.present:
            present++;
            break;
          case AttendanceStatus.late:
            late++;
            break;
          case AttendanceStatus.absent:
            absent++;
            break;
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thống kê tháng ${DateFormat.MMMM('vi').format(focusedMonth)} ${focusedMonth.year}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  title: 'Đầy đủ',
                  count: present,
                  color: Colors.green,
                  icon: Icons.check_circle,
                ),
              ),
            Expanded(
                child: _buildSummaryCard(
                  title: 'Đi muộn',
                  count: late,
                  color: Colors.orange,
                  icon: Icons.access_time,
                ),
              ),
              Expanded(
                child: _buildSummaryCard(
                  title: 'Vắng mặt',
                  count: absent,
                  color: Colors.red,
                  icon: Icons.cancel,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: present.toDouble(),
                    title: '$present',
                    color: Colors.green,
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: late.toDouble(),
                    title: '$late',
                    color: Colors.orange,
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: absent.toDouble(),
                    title: '$absent',
                    color: Colors.red,
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
                sectionsSpace: 0,
                centerSpaceRadius: 40,
                startDegreeOffset: -90,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Đầy đủ', Colors.green),
              const SizedBox(width: 16),
              _buildLegendItem('Đi muộn', Colors.orange),
              const SizedBox(width: 16),
              _buildLegendItem('Vắng mặt', Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(title),
      ],
    );
  }
}