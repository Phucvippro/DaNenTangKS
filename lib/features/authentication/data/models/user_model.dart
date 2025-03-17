import '../../domain/entities/user.dart';

class UserModel extends User {
  final String? email;
  final String? phoneNumber;
  final bool isVerified;

  const UserModel({
    required super.id,
    required super.username,
    this.email,
    this.phoneNumber,
    this.isVerified = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      isVerified: json['is_verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone_number': phoneNumber,
      'is_verified': isVerified,
    };
  }
}