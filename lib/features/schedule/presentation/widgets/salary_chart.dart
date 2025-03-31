import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/salary_info.dart';

class SalaryChart extends StatelessWidget {
  final List<SalaryInfo> salaryData;
  final int selectedYear;

  const SalaryChart({
    Key? key,
    required this.salaryData,
    required this.selectedYear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lọc dữ liệu theo năm đã chọn
    final filteredData = salaryData
        .where((salary) => salary.month.year == selectedYear)
        .toList()
      ..sort((a, b) => a.month.compareTo(b.month));

    // Tìm giá trị tối đa để tỉ lệ đồ thị
    final maxSalary = filteredData.isEmpty
        ? 0.0
        : filteredData
            .map((e) => e.totalSalary)
            .reduce((a, b) => a > b ? a : b);

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lương năm $selectedYear',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Đơn vị: Nghìn VNĐ',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
              child: filteredData.isEmpty
                  ? const Center(child: Text('Không có dữ liệu'))
                  : BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: maxSalary * 1.2,
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBorder: BorderSide(
                                color: Colors.blueGrey.withOpacity(0.8),
                                width: 1),
                            tooltipRoundedRadius: 4,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                '${NumberFormat.currency(
                                  locale: 'vi_VN',
                                  symbol: '',
                                  decimalDigits: 0,
                                ).format(rod.toY)} VNĐ',
                                const TextStyle(color: Colors.white),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() >= 0 &&
                                    value.toInt() < filteredData.length) {
                                  final month =
                                      filteredData[value.toInt()].month;
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      DateFormat('MM').format(month),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value == 0) return const SizedBox.shrink();
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    NumberFormat.compact().format(value),
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                );
                              },
                              reservedSize: 40,
                            ),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        barGroups: List.generate(filteredData.length, (index) {
                          final data = filteredData[index];
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: data.totalSalary,
                                color: Theme.of(context).primaryColor,
                                width: 20,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  topRight: Radius.circular(6),
                                ),
                                rodStackItems: [
                                  BarChartRodStackItem(
                                    0,
                                    data.baseSalary,
                                    Theme.of(context).primaryColor,
                                  ),
                                  BarChartRodStackItem(
                                    data.baseSalary,
                                    data.baseSalary + data.bonus,
                                    Colors.green,
                                  ),
                                  BarChartRodStackItem(
                                    data.baseSalary + data.bonus,
                                    data.baseSalary +
                                        data.bonus -
                                        data.deduction,
                                    Colors.red,
                                  ),
                                ],
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(
                    'Lương cơ bản', Theme.of(context).primaryColor),
                const SizedBox(width: 16),
                _buildLegendItem('Thưởng', Colors.green),
                const SizedBox(width: 16),
                _buildLegendItem('Khấu trừ', Colors.red),
              ],
            ),
            const SizedBox(height: 24),
            _buildSalaryTable(filteredData),
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
        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildSalaryTable(List<SalaryInfo> data) {
    final currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '',
      decimalDigits: 0,
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 24,
          columns: const [
            DataColumn(label: Text('Tháng')),
            DataColumn(label: Text('Lương cơ bản')),
            DataColumn(label: Text('Thưởng')),
            DataColumn(label: Text('Khấu trừ')),
            DataColumn(label: Text('Tổng lương')),
          ],
          rows: data.map((salary) {
            return DataRow(
              cells: [
                DataCell(Text(DateFormat('MM/yyyy').format(salary.month))),
                DataCell(Text('${currencyFormat.format(salary.baseSalary)}')),
                DataCell(Text('${currencyFormat.format(salary.bonus)}')),
                DataCell(Text('${currencyFormat.format(salary.deduction)}')),
                DataCell(
                  Text(
                    '${currencyFormat.format(salary.totalSalary)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
