import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/app_text_styles.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// 🟢 Wave Background (sama kayak login)
          Positioned(
            bottom: -40, // 🔧 Wave diturunkan ke bawah
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

          /// 🔵 Konten utama
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 30, bottom: 125),
                child: Center(
                  child: SizedBox(
                    width: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tombol back
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
                          hint: 'username',
                          icon: Image.asset(
                            'assets/images/img_male_user.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // No.telp
                        CustomTextField(
                          hint: 'No.telp',
                          icon: Image.asset(
                            'assets/images/img_ringer_volume.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Alamat
                        CustomTextField(
                          hint: 'Alamat',
                          icon: Image.asset(
                            'assets/images/img_address.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Password
                        CustomTextField(
                          hint: 'Password',
                          icon: Image.asset(
                            'assets/images/img_lock.png',
                            width: 20,
                            height: 20,
                          ),
                          obscureText: _obscurePassword,
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

                        // Konfirmasi Password
                        CustomTextField(
                          hint: 'Konfirmasi Password',
                          icon: Image.asset(
                            'assets/images/img_lock.png',
                            width: 20,
                            height: 20,
                          ),
                          obscureText: _obscureConfirmPassword,
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
                        const SizedBox(height: 24),

                        // Register Button
                        Center(
                          child: SizedBox(
                            width: 250,
                            child: PrimaryButton(
                              label: 'Register',
                              onPressed: () {
                                // Aksi register
                              },
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
        ],
      ),
    );
  }
}
