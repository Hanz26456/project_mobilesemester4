import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../data/services/auth_service.dart';
import '../../data/models/user_models.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  UserModel? _currentUser;
  bool _isLoading = true;
  bool _loadError = false;
  String _errorMessage = '';

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
      _loadError = false;
    });

    try {
      final user = await AuthService().getUserFromPrefs();

      if (user != null) {
        setState(() {
          _currentUser = user;
          _usernameController.text = user.username;
          _phoneController.text = user.phone;
          _addressController.text = user.address;
          _emailController.text = user.email;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _loadError = true;
          _errorMessage = 'Data pengguna tidak ditemukan.';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _loadError = true;
        _errorMessage = 'Gagal memuat profil: $e';
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.blue)) // Ganti warna jika ada AppTheme
          : _loadError
              ? _buildErrorView()
              : FadeTransition(
                  opacity: _fadeInAnimation,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/images/editprofil.png',
                              height: 180,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Edit Profil',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Bosku, mau update profil?\nGanti nama atau email biar makin kece!',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    _buildEditableTextField(
                                      controller: _usernameController,
                                      icon: const Icon(Icons.person_outline),
                                      hint: 'Username',
                                      labelText: 'Username',
                                      validator: (value) => value == null || value.isEmpty
                                          ? 'Username harus diisi'
                                          : null,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildEditableTextField(
                                      controller: _phoneController,
                                      icon: const Icon(Icons.phone),
                                      hint: 'No. Telepon',
                                      labelText: 'No. Telepon',
                                      keyboardType: TextInputType.phone,
                                      validator: (value) => value == null || value.isEmpty
                                          ? 'Nomor telepon harus diisi'
                                          : null,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildEditableTextField(
                                      controller: _addressController,
                                      icon: const Icon(Icons.location_on),
                                      hint: 'Alamat',
                                      labelText: 'Alamat',
                                      validator: (value) => value == null || value.isEmpty
                                          ? 'Alamat harus diisi'
                                          : null,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildEditableTextField(
                                      controller: _emailController,
                                      icon: const Icon(Icons.email_outlined),
                                      hint: 'Email',
                                      labelText: 'Email',
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Email harus diisi';
                                        }
                                        if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                                            .hasMatch(value)) {
                                          return 'Email tidak valid';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 24),
                                    PrimaryButton(
                                      label: 'Simpan Perubahan',
                                      onPressed: () {
                                        if (_formKey.currentState?.validate() ?? false) {
                                          _saveProfile();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget _buildEditableTextField({
    required TextEditingController controller,
    required Icon icon,
    required String hint,
    required String labelText,
    required String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return CustomTextField(
      controller: controller,
      icon: icon,
      hint: hint,
      labelText: labelText,
      keyboardType: keyboardType,
      validator: validator,
      enabled: true,
      readOnly: false,
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            const Text('Terjadi Kesalahan',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(_errorMessage, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadUserProfile,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile() {
    if (_currentUser == null) return;

    final updatedUser = UserModel(
      id: _currentUser!.id,
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      role: _currentUser!.role,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    AuthService().updateUserProfile(updatedUser).then((success) async {
      Navigator.pop(context); // Tutup loading dialog

      if (success) {
        await AuthService().saveUserToPrefs(updatedUser);
        setState(() {
          _currentUser = updatedUser; // Update state agar UI terupdate
        });
        _showSuccessDialog();
      } else {
        _showErrorDialog('Gagal memperbarui profil.');
      }
    }).catchError((error) {
      Navigator.pop(context); // Tutup loading dialog
      _showErrorDialog('Terjadi kesalahan: $error');
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Profil berhasil diperbarui'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); 
              Navigator.pop(context, true); // Bisa pop lagi jika mau kembali dan refresh screen sebelumnya
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Gagal'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

}
