import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class VerifyId implements UseCase<bool, VerifyIdParams> {
  final AuthRepository repository;

  VerifyId(this.repository);

  @override
  Future<Either<Failure, bool>> call(VerifyIdParams params) async {
    return await repository.verifyId(params.userId, params.idImagePath);
  }
}

class VerifyIdParams extends Equatable {
  final String userId;
  final String idImagePath;

  const VerifyIdParams({
    required this.userId,
    required this.idImagePath,
  });

  @override
  List<Object> get props => [userId, idImagePath];
}