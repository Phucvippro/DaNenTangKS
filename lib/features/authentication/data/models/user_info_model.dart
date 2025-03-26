import '../../domain/entities/user_info.dart';

class UserInfoModel extends UserInfo {
  UserInfoModel({
    super.id,
    super.name,
    super.email,
    super.phoneNumber,
    super.address,
    super.occupation,
    super.workplace,
    super.isVerified,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      occupation: json['occupation'],
      workplace: json['workplace'],
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'occupation': occupation,
      'workplace': workplace,
      'isVerified': isVerified,
    };
  }

  factory UserInfoModel.fromEntity(UserInfo entity) {
    return UserInfoModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      address: entity.address,
      occupation: entity.occupation,
      workplace: entity.workplace,
      isVerified: entity.isVerified,
    );
  }
}