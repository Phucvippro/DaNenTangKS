class UserInfo {
  final String? id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? address;
  final String? occupation;
  final String? workplace;
  final bool isVerified;

  UserInfo({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.address,
    this.occupation,
    this.workplace,
    this.isVerified = false,
  });

  UserInfo copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? address,
    String? occupation,
    String? workplace,
    bool? isVerified,
  }) {
    return UserInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      occupation: occupation ?? this.occupation,
      workplace: workplace ?? this.workplace,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}