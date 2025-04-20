import 'dart:async';
import 'package:flutter/material.dart';
import 'package:home_service/views/onboarding.dart';
// Ganti dengan halaman tujuan

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    // Navigasi ke halaman register setelah 3 detik
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Onboarding()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Bisa diganti dengan warna tema
      body: Center(
        child: Image.asset(
          "assets/images/logo.png", // Pastikan path sesuai
          width: 150, // Sesuaikan ukuran logo
          height: 150,
        ),
      ),
    );
  }
}
