import '../../domain/entities/salary_info.dart';

class SalaryInfoModel extends SalaryInfo {
  const SalaryInfoModel({
    required DateTime month,
    required double baseSalary,
    double bonus = 0,
    double deduction = 0,
  }) : super(
          month: month,
          baseSalary: baseSalary,
          bonus: bonus,
          deduction: deduction,
        );

  factory SalaryInfoModel.fromJson(Map<String, dynamic> json) {
    return SalaryInfoModel(
      month: DateTime.parse(json['month']),
      baseSalary: json['baseSalary'].toDouble(),
      bonus: json['bonus']?.toDouble() ?? 0.0,
      deduction: json['deduction']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month.toIso8601String(),
      'baseSalary': baseSalary,
      'bonus': bonus,
      'deduction': deduction,
    };
  }

  factory SalaryInfoModel.fromEntity(SalaryInfo entity) {
    return SalaryInfoModel(
      month: entity.month,
      baseSalary: entity.baseSalary,
      bonus: entity.bonus,
      deduction: entity.deduction,
    );
  }
}