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

  // TextEditingController
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isRegistering = false; // Flag to disable the register button
  String _selectedRole = 'customer'; // Default role

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Konfirmasi password tidak sama')),
        );
        return;
      }

      // Create request model including role
      final request = RegisterRequest(
        username: _usernameController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        email: _emailController.text,
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
        role: _selectedRole, // Add selected role to request
      );

      try {
        setState(() {
          _isRegistering = true; // Disable register button
        });

        // Call API to register
        final authService = AuthService();
        final success = await authService.register(request);

        if (success) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Register berhasil')));
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Register gagal, silakan coba lagi')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isRegistering = false; // Re-enable register button
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Wave Background (same as login)
          Positioned(
            bottom: -40, // Wave offset
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

          // Main Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 30, bottom: 125),
                child: Center(
                  child: SizedBox(
                    width: 300,
                    child: Form(
                      key: _formKey,
                      autovalidateMode:
                          AutovalidateMode
                              .onUserInteraction, // Auto validate after user interaction
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Back Button
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              'assets/images/img_back_arrow.png',
                              width: 40,
                              height: 40,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Header
                          Text('Register', style: AppTextStyles.poppinsHeading),
                          const SizedBox(height: 4),
                          Text(
                            'make your home clean with cleanfy',
                            style: AppTextStyles.interRegular.copyWith(
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Username
                          CustomTextField(
                            controller: _usernameController,
                            hint: 'Username',
                            validator:
                                (value) =>
                                    value?.isEmpty ?? true
                                        ? 'Username wajib diisi'
                                        : null,
                            icon: Image.asset(
                              'assets/images/img_male_user.png',
                              width: 20,
                              height: 20,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // No.telp
                          CustomTextField(
                            controller: _phoneController,
                            hint: 'No.telp',
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Nomor telepon wajib diisi';
                              } else if (!RegExp(
                                r'^[0-9]+$',
                              ).hasMatch(value!)) {
                                return 'Nomor telepon hanya boleh angka';
                              } else if (value.length < 10) {
                                return 'Nomor telepon minimal 10 digit';
                              }
                              return null;
                            },
                            icon: Image.asset(
                              'assets/images/img_ringer_volume.png',
                              width: 20,
                              height: 20,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Email
                          CustomTextField(
                            controller: _emailController,
                            hint: 'Email',
                            validator:
                                (value) =>
                                    value?.isEmpty ?? true
                                        ? 'Email wajib diisi'
                                        : null,
                            icon: Image.asset(
                              'assets/images/Letter.png',
                              width: 20,
                              height: 20,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Alamat
                          CustomTextField(
                            controller: _addressController,
                            hint: 'Alamat',
                            validator:
                                (value) =>
                                    value?.isEmpty ?? true
                                        ? 'Alamat wajib diisi'
                                        : null,
                            icon: Image.asset(
                              'assets/images/img_address.png',
                              width: 20,
                              height: 20,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Password
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
                            icon: Image.asset(
                              'assets/images/img_lock.png',
                              width: 20,
                              height: 20,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
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

                          // Confirm Password
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
                            icon: Image.asset(
                              'assets/images/img_lock.png',
                              width: 20,
                              height: 20,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Register Button
                          Center(
                            child:
                                _isRegistering
                                    ? CircularProgressIndicator()
                                    : SizedBox(
                                      width: 250,
                                      child: PrimaryButton(
                                        label: 'Register',
                                        onPressed:
                                            _isRegistering ? null : _register,
                                      ),
                                    ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
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