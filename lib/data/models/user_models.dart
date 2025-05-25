class UserModel {
  final int id;
  final String username;
  final String email;
  final String phone;
  final String address;
  final String role;
  String? photo;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.address,
    required this.role,
    this.photo
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      role: json['role'] ?? '',
      photo: json['photo']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'address': address,
      'role': role,
      'photo': photo,
    };
  }
}