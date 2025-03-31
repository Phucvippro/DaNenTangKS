import 'package:equatable/equatable.dart';

class SalaryInfo extends Equatable {
  final DateTime month;
  final double baseSalary;
  final double bonus;
  final double deduction;

  const SalaryInfo({
    required this.month,
    required this.baseSalary,
    this.bonus = 0,
    this.deduction = 0,
  });

  double get totalSalary => baseSalary + bonus - deduction;

  @override
  List<Object?> get props => [month, baseSalary, bonus, deduction];
}