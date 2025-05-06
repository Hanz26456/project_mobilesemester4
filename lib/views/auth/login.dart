import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../theme/app_text_styles.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../fitur/home.dart';
import '../../data/services/auth_service.dart';
import '../../data/models/login_request.dart';

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
    final email = _emailController.text;
    final password = _passwordController.text;

    final loginRequest = LoginRequest(email: email, password: password);
    final user = await AuthService().login(loginRequest);

    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', user.id);
      await prefs.setString('user_address', user.address); // 🔥 Tambahkan ini

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
          /// Background Wave
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
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

          /// Konten
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
                        Image.asset(
                          'assets/images/logo.png',
                          width: 100,
                          height: 100,
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
                              onTap: () {},
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
                        SizedBox(
                          width: 250,
                          child: PrimaryButton(
                            label: 'Login',
                            onPressed: _login,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(fontFamily: 'Inter'),
                            ),
                            const SizedBox(width: 4),
                            InkWell(
                              onTap: () {},
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
