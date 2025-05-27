import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../fitur dalam/otp.dart';
import '../../data/services/config.dart'; // Ganti sesuai nama file halaman OTP kamu

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _checkEmailAndSendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('${Config.baseUrl}/check-email'),
        body: {'email': email},
      );

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);

          if (data['status'] == 'success') {
            // Kirim OTP ke email
            final otpResponse = await http.post(
              Uri.parse('${Config.baseUrl}/send-otp'),
              body: {'email': email},
            );

            if (otpResponse.statusCode == 200) {
              try {
                final otpData = jsonDecode(otpResponse.body);

                if (otpData['status'] == 'success' && otpData['otp'] != null) {
                  print('RESPON OTP: ${otpResponse.body}');
                  print('OTP yang diterima: ${otpData['otp']}');

                  // Pastikan OTP tidak null
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => otpPage(
                        email: email,
                        otpFromServer: otpData['otp'].toString(),
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Gagal mengirim OTP: ${otpData['message']}',
                      ),
                    ),
                  );
                }
              } catch (e) {
                print('OTP JSON Error: $e\n${otpResponse.body}');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Respons OTP tidak valid')),
                );
              }
            } else {
              print(
                'OTP Status: ${otpResponse.statusCode}\n${otpResponse.body}',
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Gagal mengirim OTP')),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(data['message'] ?? 'Email tidak ditemukan'),
              ),
            );
          }
        } catch (e) {
          print('Check Email JSON Error: $e\n${response.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Respons email tidak valid')),
          );
        }
      } else {
        print('Check Email Status: ${response.statusCode}\n${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memverifikasi email')),
        );
      }
    } catch (e) {
      print('Request Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat menghubungi server')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: Image.asset('assets/images/gembokx.png', height: 100),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Forgot Password',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Lupa password? Gak masalah bossku.\nMasukkan email untuk kirim link reset',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Masukkan Email anda',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D9C73),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _isLoading ? null : _checkEmailAndSendOtp,
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              'Kirim',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
