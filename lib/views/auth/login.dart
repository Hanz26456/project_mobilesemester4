import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../theme/app_text_styles.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../fitur/home.dart';
import '../../data/services/auth_service.dart';
import '../../data/models/login_request.dart';
import '../auth/forgotpassword.dart';
import 'register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  bool _rememberMe = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan password wajib diisi.")),
      );
      return;
    }

    final loginRequest = LoginRequest(email: email, password: password);

    final user = await AuthService().login(loginRequest);

    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', user.id);
      await prefs.setString('user_address', user.address);
      await prefs.setString('email', user.email);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login gagal, coba lagi!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// 🟢 Background Wave pakai 3 SVG
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 180, // Atur tinggi sesuai keinginan
              child: Stack(
                children: [
                  // Wave pertama (Crime) - Paling bawah
                  Align(
                    alignment: Alignment.bottomRight,
                    child: SvgPicture.asset(
                      'assets/svg/Vector (2).svg',
                      width:
                          MediaQuery.of(
                            context,
                          ).size.width, // Sesuaikan dengan lebar layar
                      fit: BoxFit.cover, // Pastikan tidak terdistorsi
                    ),
                  ),
                  // Wave kedua (Hijau Tua) - Di atas wave pertama
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 30,
                      ), // Mengatur jarak antar wave
                      child: SvgPicture.asset(
                        'assets/svg/Vector.svg',
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Wave ketiga (Hijau Muda) - Paling atas
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 60,
                      ), // Mengatur jarak antar wave
                      child: SvgPicture.asset(
                        'assets/svg/Vector (1).svg',
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// 🔵 Konten utama
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: SizedBox(
                    width: 300,
                    child: Column(
                      children: [
                        const SizedBox(height: 24),

                        // Logo/Header
                        Image.asset(
                          'assets/images/logo.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'HOME SERVICE',
                          style: AppTextStyles.poppinsHeading,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Please Log in To Continue',
                          style: AppTextStyles.interRegular.copyWith(
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),

                        // Username
                        CustomTextField(
                          controller: _emailController,
                          hint: 'Email',
                          icon: Image.asset(
                            'assets/images/Letter.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Password
                        CustomTextField(
                          controller: _passwordController,
                          hint: 'Password',
                          icon: Image.asset(
                            'assets/images/img_lock.png',
                            width: 20,
                            height: 20,
                          ),
                          obscureText: _obscureText,
                          suffixIcon: IconButton(
                            icon: Icon(
                              color: Colors.grey,
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Remember me + Forgot Password link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Remember me
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  activeColor: Colors.green,
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberMe = value!;
                                    });
                                  },
                                ),
                                const Text(
                                  'Remember me',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),

                            // Forgot Password Link
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const ForgotPasswordPage(),
                                  ),
                                );
                                // Aksi navigasi ke halaman forgot password
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Login Button
                        SizedBox(
                          width: 250,
                          child: PrimaryButton(
                            label: 'Login',
                            onPressed: _login,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Sign up
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(fontFamily: 'Inter'),
                            ),
                            const SizedBox(width: 4),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const RegisterScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Sign up',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: Colors.lightBlue,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Footer
                        const Text(
                          'by logging in , you agree to the\nPrivacy Policy & Terms of Service',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 48),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
