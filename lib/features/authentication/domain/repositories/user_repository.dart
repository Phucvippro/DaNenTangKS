import 'package:dartz/dartz.dart';
import '../entities/user_info.dart';
import '../../../../core/errors/failures.dart';

abstract class UserRepository {
  Future<Either<Failure, UserInfo>> getUserInfo();
  Future<Either<Failure, bool>> addManualInfo(UserInfo userInfo);
  Future<Either<Failure, UserInfo>> verifyIdCard(String idCardData);
}