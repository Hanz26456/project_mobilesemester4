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
      title: 'Pusat Bantuan',
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
      home: const HelpCenterScreen(),
    );
  }
}

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A9D8F),
        elevation: 0,
        title: const Text(
          'Pusat Bantuan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search Bar & Header Section
            Container(
              width: double.infinity,
              color: const Color(0xFF2A9D8F),
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 5,
                bottom: 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  Container(
                    height: 50,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Cari bantuan...',
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xFF2A9D8F),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),

                  // Text
                  const Text(
                    'Hai, ada yang bisa kami bantu?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Temukan jawaban untuk pertanyaan umum dan panduan penggunaan aplikasi',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Contact Support Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF2A9D8F),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.headset_mic),
                label: const Text(
                  'Hubungi Dukungan Pelanggan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // Quick Help Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bantuan Cepat',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickHelpButton(
                          icon: Icons.book,
                          title: 'Panduan',
                          color: const Color(0xFF2A9D8F),
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _QuickHelpButton(
                          icon: Icons.videocam,
                          title: 'Tutorial',
                          color: Colors.orange[700]!,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickHelpButton(
                          icon: Icons.chat_bubble,
                          title: 'Live Chat',
                          color: Colors.blue[700]!,
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _QuickHelpButton(
                          icon: Icons.forum,
                          title: 'Forum',
                          color: Colors.purple[700]!,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // FAQ Section
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pertanyaan Umum (FAQ)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  _FAQItem(
                    question: 'Bagaimana cara mengubah kata sandi?',
                    answer:
                        'Untuk mengubah kata sandi, buka menu Pengaturan > Keamanan > Ubah Kata Sandi. Anda akan diminta memasukkan kata sandi lama dan kata sandi baru.',
                    onTap: () {},
                  ),
                  _FAQItem(
                    question: 'Bagaimana cara menghubungi dukungan?',
                    answer:
                        'Anda dapat menghubungi dukungan melalui email di support@myapp.com atau melalui fitur Live Chat di aplikasi pada jam kerja (9.00 - 17.00 WIB).',
                    onTap: () {},
                  ),
                  _FAQItem(
                    question:
                        'Aplikasi tidak dapat dibuka, apa yang harus saya lakukan?',
                    answer:
                        'Coba restart perangkat Anda. Jika masalah berlanjut, coba hapus cache aplikasi atau reinstall aplikasi. Jika masih bermasalah, hubungi dukungan kami.',
                    onTap: () {},
                  ),
                  _FAQItem(
                    question: 'Bagaimana cara melaporkan bug?',
                    answer:
                        'Untuk melaporkan bug, buka menu Pengaturan > Bantuan > Laporkan Masalah. Sertakan tangkapan layar dan deskripsi lengkap tentang masalah yang Anda alami.',
                    onTap: () {},
                  ),
                  _FAQItem(
                    question: 'Apakah data saya aman?',
                    answer:
                        'Ya, kami menggunakan enkripsi end-to-end dan protokol keamanan terbaru untuk melindungi data Anda. Untuk informasi lebih lanjut, silakan lihat Kebijakan Privasi kami.',
                    onTap: () {},
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Lihat semua FAQ',
                          style: TextStyle(
                            color: Color(0xFF2A9D8F),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: Color(0xFF2A9D8F),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Video Tutorials
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tutorial Video',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _VideoTutorialItem(
                          title: 'Perkenalan Aplikasi',
                          duration: '2:45',
                          onTap: () {},
                        ),
                        _VideoTutorialItem(
                          title: 'Cara Memulai',
                          duration: '3:12',
                          onTap: () {},
                        ),
                        _VideoTutorialItem(
                          title: 'Fitur Baru',
                          duration: '4:30',
                          onTap: () {},
                        ),
                        _VideoTutorialItem(
                          title: 'Tips & Trik',
                          duration: '5:18',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Support Channels
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Saluran Dukungan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  _SupportChannelItem(
                    icon: Icons.email,
                    title: 'Email',
                    info: 'E41232012@student.polije.ac.id',
                    onTap: () {},
                  ),
                  const Divider(),
                  _SupportChannelItem(
                    icon: Icons.phone,
                    title: 'Telepon',
                    info: '+62 8585-8931-095',
                    onTap: () {},
                  ),
                  const Divider(),
                  _SupportChannelItem(
                    icon: Icons.chat,
                    title: 'Live Chat',
                    info: 'Jam kerja: 09.00 - 17.00',
                    onTap: () {},
                  ),
                  const Divider(),
                  _SupportChannelItem(
                    icon: Icons.language,
                    title: 'Website',
                    info: 'http://aplicationhs.test/dashboard',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // Feedback Section
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2A9D8F).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.thumb_up_alt,
                    color: Color(0xFF2A9D8F),
                    size: 40,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Berikan Umpan Balik',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Bantu kami meningkatkan aplikasi dengan memberikan saran dan masukan',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF2A9D8F),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Kirim Umpan Balik',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  const Text(
                    'HomeService © 2025',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Versi 1.0.0',
                    style: TextStyle(fontSize: 12, color: Colors.grey[400]),
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

class _QuickHelpButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _QuickHelpButton({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FAQItem extends StatelessWidget {
  final String question;
  final String answer;
  final VoidCallback onTap;

  const _FAQItem({
    required this.question,
    required this.answer,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          title: Text(
            question,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          ),
          iconColor: const Color(0xFF2A9D8F),
          textColor: const Color(0xFF2A9D8F),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: Text(
                answer,
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoTutorialItem extends StatelessWidget {
  final String title;
  final String duration;
  final VoidCallback onTap;

  const _VideoTutorialItem({
    required this.title,
    required this.duration,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 150,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(
                          Icons.play_circle_fill,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        duration,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Title
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SupportChannelItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String info;
  final VoidCallback onTap;

  const _SupportChannelItem({
    required this.icon,
    required this.title,
    required this.info,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF2A9D8F), size: 22),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  info,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
