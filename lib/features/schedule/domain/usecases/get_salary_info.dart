import 'package:dartz/dartz.dart';
import '../entities/salary_info.dart';
import '../repositories/schedule_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:equatable/equatable.dart';

class GetSalaryInfo implements UseCase<List<SalaryInfo>, YearParams> {
  final ScheduleRepository repository;

  GetSalaryInfo(this.repository);

  @override
  Future<Either<Failure, List<SalaryInfo>>> call(YearParams params) async {
    return await repository.getSalaryInfo(params.year);
  }
}

class YearParams extends Equatable {
  final int year;

  const YearParams({required this.year});

  @override
  List<Object?> get props => [year];
}