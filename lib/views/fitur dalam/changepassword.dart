import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:home_service/data/services/session.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:home_service/views/auth/login.dart'; 
import '../../data/services/config.dart';
import '../auth/login.dart'; // Pastikan Config.baseUrl sudah benar

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  bool obscureOld = true;
  bool obscureNew = true;

  void _changePassword() async {
    final oldPassword = oldPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty) {
      _showDialog("Gagal", "Semua kolom wajib diisi.", false);
      return;
    }

    if (newPassword.length < 6) {
      _showDialog("Gagal", "Password baru minimal 6 karakter.", false);
      return;
    }

    // Menambahkan kondisi untuk mengecek apakah password lama dan baru sama
    if (oldPassword == newPassword) {
      _showDialog("Gagal", "Password lama dan baru tidak boleh sama.", false);
      return;
    }

    // final prefs = await SharedPreferences.getInstance();
    final user = await Sessionn.user();
    // final prefs = await SharedPreferences.getInstance();
    final token = user['token'];

    if (token == null) {
      _showDialog(
        "Gagal",
        "Token tidak ditemukan. Silakan login ulang.",
        false,
      );
      return;
    }

    final url = Uri.parse('${Config.baseUrl}/change-password');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'old_password': oldPassword,
          'new_password': newPassword,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _showDialog("Berhasil", "Password berhasil diubah.", true);
      } else if (response.statusCode == 400) {
        _showDialog("Gagal", data['message'] ?? 'Password lama salah.', false);
      } else if (response.statusCode == 422) {
        final errors = data['errors'] ?? {};
        final firstError =
            errors.values.isNotEmpty
                ? errors.values.first[0]
                : 'Validasi gagal.';
        _showDialog("Gagal", firstError, false);
      } else {
        _showDialog("Gagal", data['message'] ?? 'Terjadi kesalahan.', false);
      }
    } catch (e) {
      _showDialog("Gagal", "Gagal terhubung ke server.", false);
    }
  }

void _showDialog(String title, String message, bool success) async {
  final prefs = await SharedPreferences.getInstance();
  final userType = prefs.getString('user_type');

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          child: const Text('OK'),
          onPressed: () async {
            Navigator.of(context).pop(); // Tutup dialog
            if (success) {
              // Hapus token dan arahkan ke login
              await prefs.remove('token');
              await prefs.remove('user_type');
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()), // Ganti dengan halaman login Anda
                (route) => false,
              );
            }
          },
        ),
      ],
    ),
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 16),
              Center(
                child: Image.asset(
                  'assets/images/cpssword.png',
                  width: 180,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      'Gambar tidak ditemukan',
                      style: TextStyle(color: Colors.red),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Change Password',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ganti kata sandi yang lama dengan yang baru, tapi ini bukan hanya tentang password :)',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: oldPasswordController,
                obscureText: obscureOld,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureOld ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() => obscureOld = !obscureOld),
                  ),
                  hintText: 'Old Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newPasswordController,
                obscureText: obscureNew,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureNew ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() => obscureNew = !obscureNew),
                  ),
                  hintText: 'New Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _changePassword,
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
