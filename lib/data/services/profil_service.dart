import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/user_models.dart';
import 'config.dart';

class ProfileService {
  // Fungsi untuk mengambil profil pengguna
  static Future<UserModel> fetchUserProfile() async {
    final token = await _getToken(); // Ambil token dari SharedPreferences
    if (token == null) throw Exception('Token tidak ditemukan');

    final response = await http.get(
      Uri.parse('${Config.baseUrl}/user/profile'),
      headers: {
        'Authorization': 'Bearer $token', // Sertakan token di header
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserModel.fromJson(data['user']);
    } else {
      throw Exception('Gagal mengambil profil');
    }
  }

  // Fungsi untuk memperbarui profil pengguna
  static Future<bool> updateUserProfile(int userId, Map<String, dynamic> updatedData) async {
    final token = await _getToken(); // Ambil token dari SharedPreferences
    if (token == null) throw Exception('Token tidak ditemukan');

    final response = await http.put(
      Uri.parse('${Config.baseUrl}/user/profile'),
      headers: {
        'Authorization': 'Bearer $token', // Sertakan token di header
        'Content-Type': 'application/json',
      },
      body: json.encode(updatedData),
    );

    return response.statusCode == 200;
  }

  // Fungsi untuk mengambil token dari SharedPreferences
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}

