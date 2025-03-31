import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../errors/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// Cho các usecase không cần tham số
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}