import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tentang Aplikasi',
      theme: ThemeData(
        primaryColor: const Color(0xFF2A9D8F),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2A9D8F),
          primary: const Color(0xFF2A9D8F),
          secondary: const Color(0xFFE9C46A),
        ),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
      ),
      home: const AboutAppScreen(),
    );
  }
}

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A9D8F),
        elevation: 0,
        title: const Text(
          'Tentang Aplikasi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Navigasi kembali
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header dengan logo tanpa background putih
            Container(
              width: double.infinity,
              color: const Color(0xFF2A9D8F),
              padding: const EdgeInsets.only(top: 20, bottom: 40),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logopolosputih.png',
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'HomeService',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Versi 1.0.0',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),

            // Informasi aplikasi
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionTitle(title: 'Informasi Aplikasi'),
                  const SizedBox(height: 15),
                  _InfoItem(
                    icon: Icons.info_outline,
                    title: 'Versi',
                    subtitle: '1.0.0 (Build 2025)',
                  ),
                  _InfoItem(
                    icon: Icons.calendar_today,
                    title: 'Tanggal Rilis',
                    subtitle: 'Belum dirilis',
                  ),
                  _InfoItem(
                    icon: Icons.update,
                    title: 'Pembaruan Terakhir',
                    subtitle: 'Belum ada pembaruan',
                  ),
                  _InfoItem(
                    icon: Icons.storage,
                    title: 'Ukuran Aplikasi',
                    subtitle: '24.5 MB',
                  ),

                  const SizedBox(height: 30),
                  const _SectionTitle(title: 'Pengembang'),
                  const SizedBox(height: 15),
                  _InfoItem(
                    icon: Icons.business,
                    title: 'Perusahaan',
                    subtitle: 'Kelompok 2 - Kampus Bondowoso',
                  ),
                  _InfoItem(
                    icon: Icons.public,
                    title: 'Website',
                    subtitle: 'http://aplicationhs.test/dashboard',
                    isLink: true,
                  ),
                  _InfoItem(
                    icon: Icons.email,
                    title: 'Email',
                    subtitle: 'e41232012@student.polije.ac.id',
                    isLink: true,
                  ),

                  const SizedBox(height: 30),
                  const _SectionTitle(title: 'Fitur Terbaru'),
                  const SizedBox(height: 15),
                  const _FeatureItem(
                    title: 'Antarmuka Baru',
                    description: 'Desain yang lebih modern dan mudah digunakan',
                  ),
                  const _FeatureItem(
                    title: 'Pesan layanan',
                    description: 'Pesan layanan dengan mudah dan cepat',
                  ),
                  const _FeatureItem(
                    title: 'Peningkatan Performa',
                    description: 'Aplikasi berjalan lebih cepat dan responsif',
                  ),
                  const _FeatureItem(
                    title: 'Keamanan Data',
                    description:
                        'Data pengguna lebih aman dengan enkripsi terbaru',
                  ),

                  const SizedBox(height: 30),
                  const _SectionTitle(title: 'Legal'),
                  const SizedBox(height: 15),
                  _LegalButton(title: 'Kebijakan Privasi', onPressed: () {}),
                  const SizedBox(height: 10),
                  _LegalButton(title: 'Syarat & Ketentuan', onPressed: () {}),
                  const SizedBox(height: 10),
                  Text(
                    '© 2025 Kelompok 2 - HomeServiceApp. Semua hak dilindungi.',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Dibuat Oleh Mahasiswa Politeknik Negeri Jember',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2A9D8F),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isLink;

  const _InfoItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isLink = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF2A9D8F).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF2A9D8F), size: 22),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 15,
                    color: isLink ? const Color(0xFF2A9D8F) : Colors.grey[600],
                    fontWeight: isLink ? FontWeight.w500 : FontWeight.normal,
                    decoration:
                        isLink ? TextDecoration.underline : TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String title;
  final String description;

  const _FeatureItem({required this.title, required this.description, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFF2A9D8F),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegalButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const _LegalButton({required this.title, required this.onPressed, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.grey[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 5),
            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }
}
