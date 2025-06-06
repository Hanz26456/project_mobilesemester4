import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../theme/app_text_styles.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../../data/models/register_request.dart';
import '../../data/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isRegistering = false;
  String _selectedRole = 'customer';

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Konfirmasi password tidak sama')),
        );
        return;
      }

      final request = RegisterRequest(
        username: _usernameController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        email: _emailController.text,
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
        role: _selectedRole,
      );

      try {
        setState(() {
          _isRegistering = true;
        });

        final authService = AuthService();
        final success = await authService.register(request);

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Register berhasil')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Register gagal, silakan coba lagi')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isRegistering = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Wave background
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
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

          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(
                        'assets/images/img_back_arrow.png',
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Register', style: AppTextStyles.poppinsHeading),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'make your home clean with cleanfy',
                      style: AppTextStyles.interRegular.copyWith(fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomTextField(
                              controller: _usernameController,
                              hint: 'Username',
                              validator: (value) =>
                                  value?.isEmpty ?? true ? 'Username wajib diisi' : null,
                              icon: Image.asset('assets/images/img_male_user.png', width: 20),
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              controller: _phoneController,
                              hint: 'No.telp',
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Nomor telepon wajib diisi';
                                } else if (!RegExp(r'^[0-9]+$').hasMatch(value!)) {
                                  return 'Nomor telepon hanya boleh angka';
                                } else if (value.length < 10) {
                                  return 'Nomor telepon minimal 10 digit';
                                }
                                return null;
                              },
                              icon: Image.asset('assets/images/img_ringer_volume.png', width: 20),
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              controller: _emailController,
                              hint: 'Email',
                              validator: (value) =>
                                  value?.isEmpty ?? true ? 'Email wajib diisi' : null,
                              icon: Image.asset('assets/images/Letter.png', width: 20),
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              controller: _addressController,
                              hint: 'Alamat',
                              validator: (value) =>
                                  value?.isEmpty ?? true ? 'Alamat wajib diisi' : null,
                              icon: Image.asset('assets/images/img_address.png', width: 20),
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              controller: _passwordController,
                              hint: 'Password',
                              obscureText: _obscurePassword,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Password wajib diisi';
                                } else if (value!.length < 6) {
                                  return 'Password minimal 6 karakter';
                                }
                                return null;
                              },
                              icon: Image.asset('assets/images/img_lock.png', width: 20),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              controller: _confirmPasswordController,
                              hint: 'Konfirmasi Password',
                              obscureText: _obscureConfirmPassword,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Konfirmasi password wajib diisi';
                                } else if (value != _passwordController.text) {
                                  return 'Konfirmasi password tidak sama';
                                }
                                return null;
                              },
                              icon: Image.asset('assets/images/img_lock.png', width: 20),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 24),
                            _isRegistering
                                ? const CircularProgressIndicator()
                                : SizedBox(
                                    width: 250,
                                    child: PrimaryButton(
                                      label: 'Register',
                                      onPressed: _register,
                                    ),
                                  ),
                            const SizedBox(height: 150),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}