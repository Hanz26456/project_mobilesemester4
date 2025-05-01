import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/register_request.dart';
import '../models/login_request.dart';
import '../models/user_models.dart';

class AuthService {
  static const String baseUrl =
      "http://192.168.1.6:8000/api"; // Pastikan URL benar

  // ✅ REGISTER
  Future<bool> register(RegisterRequest request) async {
    final url = Uri.parse('$baseUrl/register');
    final body = json.encode(request.toJson());

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        print("Registrasi berhasil: ${data['message']}");
        return true;
      } else {
        final data = json.decode(response.body);
        print("Gagal registrasi: ${data['message'] ?? 'Unknown error'}");
        return false;
      }
    } catch (e) {
      print("Error saat melakukan registrasi: $e");
      return false;
    }
  }

  // ✅ LOGIN
  Future<UserModel?> login(LoginRequest request) async {
    final url = Uri.parse('$baseUrl/login');
    final body = json.encode(request.toJson());

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'];
        final userData = data['user'];

        // Simpan token dan data user menggunakan shared_preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token); // Menyimpan token

        // Simpan data user sebagai JSON string
        await prefs.setString('user_data', json.encode(userData));

        print("Login berhasil! Token dan data user disimpan.");

        // Mengembalikan UserModel dengan data pengguna yang login
        return UserModel.fromJson(userData);
      } else {
        final data = json.decode(response.body);
        print("Login gagal: ${data['message'] ?? 'Unknown error'}");
        return null;
      }
    } catch (e) {
      print("Error saat login: $e");
      return null;
    }
  }
}
