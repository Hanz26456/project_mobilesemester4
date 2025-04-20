import 'package:flutter/material.dart';
import 'package:home_service/utils/colors.dart';
import 'package:home_service/views/welcome.dart';
import '../widgets/primary_button.dart'; // ✅ Pastikan ini di-import

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _pageController = PageController(keepPage: true);
  int _currentPage = 0;

  void _onLanjutkanPressed() {
    if (_currentPage < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    }
  }

  void _onLewatiPressed() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WelcomeScreen()),
    );
  }

  List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/onboarding1.png",
      "title": "Monitor Kualitas Udara\nReal-Time",
      "description":
          "Pantau tingkat polusi udara, konsentrasi partikel\nberbahaya, dan indeks kualitas udara dengan\nakurat",
    },
    {
      "image": "assets/images/onboarding2.png",
      "title": "Lihat Data Kapan Saja",
      "description":
          "Akses informasi tentang kualitas udara\ndi sekitar Anda kapan saja dan di mana saja",
    },
    {
      "image": "assets/images/onboarding3.png",
      "title": "Solusi untuk Hidup Sehat",
      "description":
          "Dapatkan rekomendasi terbaik untuk\nmenjaga kesehatan di lingkungan Anda",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: onboardingData.length,
              physics: BouncingScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      onboardingData[index]["image"]!,
                      width: 300,
                      height: 250,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 30),
                    Text(
                      onboardingData[index]["title"]!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        onboardingData[index]["description"]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: grayColor,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Indikator halaman
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              onboardingData.length,
              (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 16 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index ? greenCOlor : grayColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          // Tombol Lanjutkan / Mulai Sekarang
          SizedBox(
            width: 250,
            child: PrimaryButton(
              label:
                  _currentPage == onboardingData.length - 1
                      ? "Mulai Sekarang"
                      : "Lanjutkan",
              onPressed: _onLanjutkanPressed,
            ),
          ),

          SizedBox(height: 15),

          // Tombol Lewati (secondary style)
          TextButton(
            onPressed: _onLewatiPressed,
            child: Text(
              "Lewati",
              style: TextStyle(
                fontFamily: "Inter",
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: greenCOlor,
              ),
            ),
          ),

          SizedBox(height: 40),
        ],
      ),
    );
  }
}
