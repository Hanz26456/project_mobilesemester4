import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../data/models/user_models.dart';
import '../../data/services/profil_service.dart'; // Import service baru

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _isEditing = false;
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final user = await ProfileService.fetchUserProfile(); // ID user bisa didapatkan dari token atau SharedPreferences
      setState(() {
        _user = user;
        _usernameController.text = user.username;
        _emailController.text = user.email;
        _phoneController.text = user.phone;
        _addressController.text = user.address;
      });
    } catch (e) {
      _showError('Terjadi kesalahan: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedData = {
        'username': _usernameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
      };

      try {
        final success = await ProfileService.updateUserProfile(_user!.id, updatedData);

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profil berhasil diperbarui!')),
          );
          _toggleEditing();
        } else {
          _showError('Gagal menyimpan perubahan profil');
        }
      } catch (e) {
        _showError('Terjadi kesalahan saat menyimpan profil');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: _toggleEditing,
          ),
        ],
      ),
      body: _user == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    CustomTextField(
                      controller: _usernameController,
                      hint: 'Username',
                      icon: const Icon(Icons.person),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Username harus diisi' : null,
                      enabled: _isEditing,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _emailController,
                      hint: 'Email',
                      icon: const Icon(Icons.email),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Email harus diisi';
                        if (!RegExp(r"^[\w\.-]+@[\w\.-]+\.\w+$").hasMatch(value)) {
                          return 'Format email salah';
                        }
                        return null;
                      },
                      enabled: _isEditing,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _phoneController,
                      hint: 'No. Telepon',
                      icon: const Icon(Icons.phone),
                      keyboardType: TextInputType.phone,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Nomor telepon harus diisi' : null,
                      enabled: _isEditing,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _addressController,
                      hint: 'Alamat',
                      icon: const Icon(Icons.location_on),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Alamat harus diisi' : null,
                      enabled: _isEditing,
                    ),
                    const SizedBox(height: 32),
                    if (_isEditing)
                      PrimaryButton(
                        label: 'Simpan',
                        onPressed: _saveProfile,
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
