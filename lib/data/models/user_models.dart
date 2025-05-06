class UserModel {
  final int id;
  final String username;
  final String email;
  final String phone;
  final String address;
  final String role;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.address,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      role: json['role'],
    );
  }

  // Menambahkan metode toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'address': address,
      'role': role,
    };
  }
}
