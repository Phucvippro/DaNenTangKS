import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> signIn(String username, String password) async {
    try {
      final userModel = await remoteDataSource.signIn(username, password);
      await localDataSource.cacheUser(userModel);
      return Right(userModel);
    } on InvalidCredentialsFailure {
      return Left(InvalidCredentialsFailure());
    } on ServerFailure {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signUp(String username, String password) async {
    try {
      final userModel = await remoteDataSource.signUp(username, password);
      await localDataSource.cacheUser(userModel);
      return Right(userModel);
    } on UserAlreadyExistsFailure {
      return Left(UserAlreadyExistsFailure());
    } on ServerFailure {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> verifyId(String userId, String idImagePath) async {
    try {
      final isVerified = await remoteDataSource.verifyId(userId, idImagePath);
      return Right(isVerified);
    } on VerificationFailure {
      return Left(VerificationFailure());
    } on ServerFailure {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}