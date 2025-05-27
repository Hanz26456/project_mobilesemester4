import 'dart:convert';
import 'package:home_service/data/services/database.dart';
import 'package:home_service/data/services/session.dart';
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
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        final token = data['token'];
        final user = UserModel.fromJson(data['user']);
        UserModel dataa = UserModel(
          id: user.id,
          username: user.username,
          email: user.email,
          phone: user.phone,
          address: user.address,
          role: user.role,
          photo: user.photo,
          token: token,
        );
        // print("sada token${dataa.toJson()}");

        await DatabaseHelper().insertUser(dataa);
        // final prefs = await SharedPreferences.getInstance();
        // await prefs.setString('token', token);

        // // ✅ Simpan data user ke SharedPreferences
        // await prefs.setInt('id', user.id);
        // await prefs.setString('username', user.username);
        // await prefs.setString('email', user.email);
        // await prefs.setString('phone', user.phone);
        // await prefs.setString('address', user.address);
        // await prefs.setString('role', user.role);

        return user;
      } else {
        print("Login gagal: ${data['message'] ?? 'Unknown error'}");
        return null;
      }
    } catch (e) {
      print("Error saat login: $e");
      return null;
    }
  }

  //simpan data register
  Future<void> saveUserToPrefs(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id', user.id);
    await prefs.setString('username', user.username);
    await prefs.setString('email', user.email);
    await prefs.setString('phone', user.phone);
    await prefs.setString('address', user.address);
    await prefs.setString('role', user.role);
  }

  Future<UserModel?> getUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final id = prefs.getInt('id');
    final username = prefs.getString('username');
    final email = prefs.getString('email');
    final phone = prefs.getString('phone');
    final address = prefs.getString('address');
    final role = prefs.getString('role');
    final photo = prefs.getString('photo');

    if (id != null &&
        username != null &&
        email != null &&
        phone != null &&
        address != null &&
        role != null) {
      return UserModel(
        id: id,
        username: username,
        email: email,
        phone: phone,
        address: address,
        role: role,
        photo: photo,
      );
    } else {
      return null;
    }
  }

  // edit profil
  Future<UserModel?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print('Token tidak ditemukan. Pengguna belum login.');
      return null;
    }

    final url = Uri.parse(
      '${Config.baseUrl}/profile',
    ); // Ganti dengan endpoint yang sesuai

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = json.decode(response.body);
      // print('Response body:\n${response.body}');
      if (response.statusCode == 200) {
        print('Data profil berhasil diambil');
        return UserModel.fromJson(
          data,
        ); // Menggunakan data langsung jika tidak ada key 'user'
      } else {
        print('Gagal mengambil profil: ${data['message'] ?? 'Unknown error'}');
        return null;
      }
    } catch (e) {
      print('Error saat mengambil profil: $e');
      return null;
    }
  }

  Future<bool> updateUserProfile(UserModel user) async {
    // print(token);
    if (user.token == null) {
      print('Token tidak ditemukan. Pengguna belum login.');
      return false;
    }

    final url = Uri.parse('${Config.baseUrl}/profile/update');
    final body = json.encode(user.toJson()); // Pastikan menggunakan toJson()
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'aplication/json',
          'Authorization': 'Bearer ${user.token}',
          'Accept': 'aplication/json',
        },
        body: body,
      );
      // print('Response body:\n${response.body}');

      if (response.statusCode == 200) {
        print('Profil berhasil diperbarui');
        return true;
      } else {
        final data = json.decode(response.body);
        print(
          'Gagal memperbarui profil: ${data['message'] ?? 'Unknown error'}',
        );
        return false;
      }
    } catch (e) {
      print('Error saat memperbarui profil: $e');
      return false;
    }
  }
}
