import 'package:flutter/material.dart';
import '../auth/login.dart';
import '../fitur dalam/changepassword.dart';
import '../fitur dalam/editprofil.dart';
import '../fitur dalam/aboutapp.dart';
import '../fitur dalam/pusatbantuan.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 16,
            ),
            child: Column(
              children: [
                // Header (Judul halaman)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'Profil',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Profile Picture
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade300,
                  ),
                  // Jika ada foto profil:
                  // child: Image.network('URL_FOTO', fit: BoxFit.cover),
                ),

                const SizedBox(height: 16),

                // Name
                const Text(
                  'Jamal',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                // Email
                Text(
                  'Ngodfingbang@gmail.com',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),

                const SizedBox(height: 32),

                // Menu Items
                _buildMenuItem(context, 'Edit Profil', Icons.edit_note, () {
                  // Navigate to edit profile screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                }),

                _buildMenuItem(
                  context,
                  'Ganti Password',
                  Icons.lock_outline,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangePassword(),
                      ),
                    );
                  },
                ),

                _buildMenuItem(
                  context,
                  'Pusat Bantuan',
                  Icons.help_outline,
                  () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpCenterScreen(),
                   ),
                    );
                  },
                ),

                _buildMenuItem(
                  context,
                  'Tentang Aplikasi',
                  Icons.info_outline,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutAppScreen(),
                   ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Logout Button
                Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.grey.shade100,
    ),
    child: ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.logout, color: Colors.red.shade600),
      ),
      title: Text(
        'Log Out',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.red.shade600,
        ),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Konfirmasi'),
            content: const Text('Apakah Anda yakin ingin keluar?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup dialog
                  
                  // Tampilkan snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Berhasil logout'),
                    ),
                  );
                  
                  // Pergi ke halaman Login
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(), // Ganti LoginPage dengan nama file login kamu
                    ),
                  );
                },
                child: Text(
                  'Ya, Keluar',
                  style: TextStyle(
                    color: Colors.red.shade600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  ),
),


                // Menghapus Spacer() yang menyebabkan overflow
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.grey.shade600),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}