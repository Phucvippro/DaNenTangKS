import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  /// Đăng nhập người dùng
  /// 
  /// Trả về [User] nếu thành công hoặc [Failure] nếu thất bại
  Future<Either<Failure, User>> signIn(String username, String password);
  
  /// Đăng ký người dùng mới
  /// 
  /// Trả về [User] nếu thành công hoặc [Failure] nếu thất bại
  Future<Either<Failure, User>> signUp(String username, String password);
  
  /// Xác minh căn cước của người dùng
  /// 
  /// Trả về [bool] nếu thành công hoặc [Failure] nếu thất bại
  Future<Either<Failure, bool>> verifyId(String userId, String idImagePath);
}