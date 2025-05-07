import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/register_request.dart';
import '../models/login_request.dart';
import '../models/user_models.dart';
import 'config.dart';

class AuthService {
  // 🔸 REGISTER
  Future<bool> register(RegisterRequest request) async {
    final url = Uri.parse('${Config.baseUrl}/register');
    final body = json.encode(request.toJson());

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      final data = json.decode(response.body);

      if (response.statusCode == 201) {
        print("Registrasi berhasil: ${data['message']}");
        return true;
      } else {
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
    final url = Uri.parse('${Config.baseUrl}/login');
    final body = json.encode(request.toJson());

    try {
      print("Login body: $body"); // 🔍 Debug isi body

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        final token = data['token'];

        // ✅ Simpan token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        print("Login berhasil! Token disimpan.");

        // 🔁 Return user
        return UserModel.fromJson(data['user']);
      } else {
        print("Login gagal: ${data['message'] ?? 'Unknown error'}");
        return null;
      }
    } catch (e) {
      print("Error saat login: $e");
      return null;
    }
  }
}
