import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:home_service/data/services/database.dart';
import 'package:home_service/data/services/session.dart';
import 'package:home_service/data/services/upload_profile_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../auth/login.dart';
import '../fitur dalam/changepassword.dart';
import '../../data/models/user_models.dart';
import '../../data/services/config.dart';

class ProfilePekerja extends StatefulWidget {
  const ProfilePekerja({super.key});

  @override
  State<ProfilePekerja> createState() => _ProfilePekerjaState();
}

class _ProfilePekerjaState extends State<ProfilePekerja> {
  Map<String, dynamic>? currentUser;
  bool isLoading = true;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  // Tema warna hijau
  final Color primaryColor = const Color(0xFF2E7D32); // Hijau tua
  final Color accentColor = const Color(0xFF81C784); // Hijau muda
  final Color lightGreen = const Color(0xFFE8F5E9); // Hijau sangat muda

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkLoginStatus();
  }

  Future<void> _loadUserData() async {
    // final prefs = await SharedPreferences.getInstance();
    final user = await Sessionn.user();
    // final prefs = await SharedPreferences.getInstance();
    final userJson = user;
    if (userJson != null) {
      setState(() {
        currentUser = user;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _checkLoginStatus() async {
    // final prefs = await SharedPreferences.getInstance();
    final user = await Sessionn.user();
    // final prefs = await SharedPreferences.getInstance();
    if (!user["username"] == "") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      _loadUserData();
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Pilih Sumber Foto',
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: lightGreen,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.camera_alt, color: primaryColor),
                ),
                title: const Text('Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: lightGreen,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.photo_library, color: primaryColor),
                ),
                title: const Text('Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Batal',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          // print(_imageFile);
        });
        await _uploadProfilePhoto();
      }
    } catch (e) {
      _showErrorSnackBar('Gagal memilih foto: $e');
    }
  }

  Future<void> _uploadProfilePhoto() async {
    if (_imageFile == null || currentUser == null) return;

    try {
      _showLoadingDialog();

      // final prefs = await SharedPreferences.getInstance();
      // var token = prefs.getString('token');
      final user = await Sessionn.user();
      // final prefs = await SharedPreferences.getInstance();
      final token = user['token'];
      var userId = currentUser?["user_id"];
      // print(_imageFile);
      final response = await UploadProfileService.uploadProfilePhoto(
        _imageFile,
        token,
        userId.toString(),
      );

      Navigator.pop(context); // Tutup dialog loading
      // print('Upload response: $response');

      if (response != null && response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          setState(() {
            currentUser!["photo"] = jsonResponse['photo_url'];
            _imageFile = null; // Reset _imageFile setelah upload
          });
          final dbHelper = DatabaseHelper();
          await dbHelper.updateUser(
            UserModel(
              id: currentUser?["user_id"],
              username: currentUser?["username"],
              email: currentUser?["email"],
              address: currentUser?["address"],
              role: currentUser?["role"],
              photo: jsonResponse['photo_url'],
              token: currentUser?["token"],
              phone: currentUser?["phone"] ?? '',
            ),
          );
          _showSuccessSnackBar('Foto profil berhasil diperbarui!');
        } else {
          _showErrorSnackBar(jsonResponse['message'] ?? 'Upload gagal');
        }
      } else {
        _showErrorSnackBar('Server error: ${response?.statusCode}');
      }
    } catch (e) {
      Navigator.pop(context);
      print('Upload error: $e');
      _showErrorSnackBar('Error: $e');
    }
  }

  ImageProvider? _getProfileImage() {
    if (_imageFile != null) {
      print('Using local image file: ${_imageFile!.path}');
      return FileImage(_imageFile!);
    }

    final photo = currentUser?["photo"];
    //rint( 'Photo from UserModel: $photo');

    if (photo != null && photo.isNotEmpty) {
      final photoUrl =
          photo.startsWith('http') ? photo : Config.getProfilePhotoUrl(photo);

      return NetworkImage(
        '$photoUrl?timestamp=${DateTime.now().millisecondsSinceEpoch}',
      );
    }

    print('No profile image available, using default');
    return const AssetImage('assets/default_profile.png'); // Gambar default
  }

  Widget _buildProfilePhoto() {
    return Hero(
      tag: 'profile-photo',
      child: GestureDetector(
        onTap: _showImageSourceDialog,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: lightGreen,
                backgroundImage: _getProfileImage(),
                onBackgroundImageError: (e, __) {
                  print(e);
                },
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: primaryColor),
              const SizedBox(height: 16),
              const Text('Mengupload foto...'),
            ],
          ),
        );
      },
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(message),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Profil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator(color: primaryColor))
              : currentUser == null
              ? Center(
                child: Text(
                  'Data pengguna tidak ditemukan',
                  style: TextStyle(color: primaryColor),
                ),
              )
              : Stack(
                children: [
                  // Background dengan gradien hijau
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [primaryColor, accentColor],
                      ),
                    ),
                  ),

                  // Pola dekoratif
                  Positioned(
                    top: -50,
                    right: -50,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 50,
                    left: -30,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),

                  SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 30),
                          // Foto profil
                          _buildProfilePhoto(),
                          const SizedBox(height: 25),

                          // Card untuk informasi profil
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Username
                                Text(
                                  currentUser!["username"],
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                // Email dengan ikon
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.email_rounded,
                                      size: 16,
                                      color: accentColor,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      currentUser!["email"],
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 15),

                                // Divider dengan gradien
                                Container(
                                  height: 2,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        accentColor.withOpacity(0.5),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 15),

                                // Status atau info tambahan (contoh saja)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildInfoItem(
                                      'Status',
                                      'Aktif',
                                      Icons.check_circle_outline_rounded,
                                    ),
                                    _buildInfoItem(
                                      'Bergabung',
                                      'Mei 2025',
                                      Icons.date_range_rounded,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 25),

                          // Menu pengaturan
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 16,
                                    top: 16,
                                    bottom: 8,
                                  ),
                                  child: Text(
                                    'Pengaturan Akun',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),

                                _buildAnimatedMenuItem(
                                  context,
                                  'Ganti Password',
                                  Icons.lock_outline_rounded,
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => const ChangePassword(),
                                      ),
                                    );
                                  },
                                  primaryColor,
                                  lightGreen,
                                ),

                                // Opsi menu tambahan (placeholder)
                                _buildAnimatedMenuItem(
                                  context,
                                  'Notifikasi',
                                  Icons.notifications_none_rounded,
                                  () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Fitur notifikasi akan segera hadir',
                                        ),
                                        backgroundColor: primaryColor,
                                      ),
                                    );
                                  },
                                  primaryColor,
                                  lightGreen,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 25),

                          // Tombol Logout
                          Container(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.logout_rounded),
                              label: const Text('Keluar'),
                              onPressed: () {
                                // Dialog konfirmasi
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Konfirmasi Keluar',
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Text(
                                        'Apakah Anda yakin ingin keluar dari akun ini?',
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'Batal',
                                            style: TextStyle(
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            // final prefs =
                                            //     await SharedPreferences.getInstance();
                                            // await prefs.remove('user_data');
                                            await DatabaseHelper().deleteUser();
                                            Navigator.of(context).pop();
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        const LoginScreen(),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.red.shade400,
                                            foregroundColor: Colors.white,
                                          ),
                                          child: const Text('Ya, Keluar'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade100,
                                foregroundColor: Colors.red.shade700,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Versi aplikasi
                          Text(
                            'Aplikasi Versi 1.0.0',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  // Widget untuk menu item dengan animasi
  Widget _buildAnimatedMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
    Color primaryColor,
    Color lightGreen,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          splashColor: lightGreen,
          highlightColor: lightGreen.withOpacity(0.3),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: lightGreen,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: primaryColor, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: primaryColor.withOpacity(0.7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget untuk informasi tambahan
  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: accentColor),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade900,
            ),
          ),
        ],
      ),
    );
  }
}
