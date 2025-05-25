import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../theme/app_text_styles.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../data/services/auth_service.dart';
import '../../data/models/login_request.dart';
import '../auth/forgotpassword.dart';
import 'register.dart';
import '../fitur/home.dart';
import '../pekerja/dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan password wajib diisi.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final loginRequest = LoginRequest(email: email, password: password);
    final user = await AuthService().login(loginRequest);

    setState(() {
      _isLoading = false;
    });

    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', user.id);
      await prefs.setString('user_address', user.address);
      await prefs.setString('email', user.email);
      await prefs.setString('user_data', json.encode(user.toJson()));
      await prefs.setString('role', user.role);
      await prefs.setString('photo', user.photo ?? '');

      if (user.role == 'worker') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboardp()),
        );
      } else if (user.role == 'customer') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Role tidak dikenali: ${user.role}')),
        );
      }
    } else {
      _showLoginErrorDialog('Email atau password salah.');
    }
  }

  void _showLoginErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Login Gagal'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false, // agar wave tetap di bawah saat keyboard muncul
      body: Stack(
        children: [
          // Background SVG Wave
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: IgnorePointer(
                child: SizedBox(
                  height: 180,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: SvgPicture.asset(
                          'assets/svg/Vector (2).svg',
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: SvgPicture.asset(
                            'assets/svg/Vector.svg',
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 60),
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
            ),
          ),

          // Teks Privacy Policy di area wave
          Positioned(
            bottom: 100,
            left: 100,
            right: 0,
            child: Center(
              child: Text(
                'by logging in , you agree to the\nPrivacy Policy & Terms of Service',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 2,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: Container(
                    width: double.infinity,
                    height: constraints.maxHeight,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 80),

                        // Logo
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

                        // Email
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
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Remember + Forgot
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const ForgotPasswordPage(),
                                  ),
                                );
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

                        const Spacer(), // Jaga agar ada ruang untuk wave
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}