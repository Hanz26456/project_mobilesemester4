import 'package:flutter/material.dart';
import 'package:home_service/utils/colors.dart';
import 'package:home_service/views/login.dart';
import 'package:home_service/views/register.dart';
import '../widgets/primary_button.dart'; // Pastikan import ini ada

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Text(
                  "Selamat Datang di Home Service",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Temukan layanan perbaikan rumah terbaik dengan mudah dan cepat.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: grayColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Gambar Welcome di bawah teks
          Image.asset(
            "assets/images/welcome.png",
            width: 300,
            height: 250,
            fit: BoxFit.contain,
          ),

          const SizedBox(height: 40),

          // Tombol Buat Akun
          SizedBox(
            width: 250,
            child: PrimaryButton(
              label: "Buat Akun",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                );
              },
            ),
          ),

          const SizedBox(height: 15),

          // Tombol Masuk (dengan tampilan link biru)
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: Text(
              "Masuk",
              style: TextStyle(
                fontFamily: "Inter",
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: greenCOlor,
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
