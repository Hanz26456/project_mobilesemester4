import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header with Back Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
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
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Email
            Text(
              'Ngodfingbang@gmail.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Menu Items
            _buildMenuItem(
              context,
              'Edit Profil',
              Icons.edit_note,
              () {
                // Navigate to edit profile
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit Profil diklik')),
                );
              },
            ),
            
            _buildMenuItem(
              context,
              'Ganti Password',
              Icons.lock_outline,
              () {
                // Navigate to change password
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ganti Password diklik')),
                );
              },
            ),
            
            _buildMenuItem(
              context,
              'Alamat Saya',
              Icons.location_on_outlined,
              () {
                // Navigate to addresses
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Alamat Saya diklik')),
                );
              },
            ),
            
            _buildMenuItem(
              context,
              'Pusat Bantuan',
              Icons.help_outline,
              () {
                // Navigate to help center
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pusat Bantuan diklik')),
                );
              },
            ),
            
            _buildMenuItem(
              context,
              'Tentang Aplikasi',
              Icons.info_outline,
              () {
                // Navigate to about page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tentang Aplikasi diklik')),
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
                    child: Icon(
                      Icons.logout,
                      color: Colors.red.shade600,
                    ),
                  ),
                  title: Text(
                    'Log Out',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade600,
                    ),
                  ),
                  onTap: () {
                    // Handle logout
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
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Berhasil logout')),
                              );
                            },
                            child: Text(
                              'Ya, Keluar',
                              style: TextStyle(color: Colors.red.shade600),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            
            const Spacer(),
            
            // Updated Bottom Navigation Bar
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavBarItem(context, Icons.home_outlined, 'Beranda', 0, false),
                    _buildNavBarItem(context, Icons.settings_outlined, 'Layanan', 1, false),
                    _buildNavBarItem(context, Icons.person, 'Profil', 2, true),
                    _buildNavBarItem(context, Icons.history_outlined, 'Riwayat', 3, false),
                  ],
                ),
              ),
            ),
          ],
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
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.grey.shade600,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
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

  Widget _buildNavBarItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        if (!isSelected && index != 2) {
          // Handle navigation to other screens based on index
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/services');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/history');
              break;
          }
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.green.shade800 : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.green.shade800 : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}