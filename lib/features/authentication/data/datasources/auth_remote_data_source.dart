import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/errors/failures.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Gọi API đăng nhập
  ///
  /// Ném [ServerException] nếu có lỗi xảy ra
  Future<UserModel> signIn(String username, String password);

  /// Gọi API đăng ký
  ///
  /// Ném [ServerException] nếu có lỗi xảy ra
  Future<UserModel> signUp(String username, String password);

  /// Gọi API xác minh căn cước
  ///
  /// Ném [ServerException] nếu có lỗi xảy ra
  Future<bool> verifyId(String userId, String idImagePath);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final String baseUrl = 'https://localhost:7260/api';

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> signIn(String username, String password) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/User/Login'),
        body: json.encode({
          'username': username,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        throw InvalidCredentialsFailure();
      } else {
        throw ServerFailure();
      }
    } catch (e) {
      throw ServerFailure();
    }
  }

  @override
  Future<UserModel> signUp(String username, String password) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/User/CreateUser'),
        body: json.encode({
          'username': username,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        return UserModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 409) {
        throw UserAlreadyExistsFailure();
      } else {
        throw ServerFailure();
      }
    } catch (e) {
      throw ServerFailure();
    }
  }

  @override
  Future<bool> verifyId(String userId, String idImagePath) async {
    // Thực hiện upload hình ảnh và xác minh ID
    // Đây là một mẫu đơn giản, cần thêm logic xử lý upload file
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/auth/verify-id'),
        body: json.encode({
          'user_id': userId,
          'id_image_path': idImagePath,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw VerificationFailure();
      }
    } catch (e) {
      throw ServerFailure();
    }
  }
}