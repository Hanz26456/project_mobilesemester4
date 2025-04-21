class RegisterRequest {
  final String username;
  final String email;
  final String phone;
  final String address;
  final String password;
  final String passwordConfirmation;
  final String role;

  RegisterRequest({
    required this.username,
    required this.email, // Menambahkan email
    required this.phone,
    required this.address,
    required this.password,
    required this.passwordConfirmation, // Menambahkan password_confirmation
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email, // Kirimkan email
      'phone': phone,
      'address': address,
      'password': password,
      'password_confirmation': passwordConfirmation, // Kirimkan password_confirmation
      'role': role,
    };
  }
}
