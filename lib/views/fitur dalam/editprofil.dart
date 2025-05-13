import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../data/services/auth_service.dart';
import '../../data/models/user_models.dart';

void main() {
  runApp(const MyApp());
}

// Define AppTheme here to avoid import issues
class AppTheme {
  static const Color primaryColor = Color(0xFF2A9D8F);
  static const Color secondaryColor = Color(0xFFE9C46A);
  static const Color accentColor = Color(0xFFE76F51);
  static const Color neutralDark = Color(0xFF264653);
  static const Color neutralLight = Color(0xFFF4F1DE);

  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textLight = Color(0xFF999999);

  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundWhite = Color(0xFFFFFFFF);

  static const Color success = Color(0xFF2A9D8F);
  static const Color error = Color(0xFFE76F51);
  static const Color warning = Color(0xFFE9C46A);
  static const Color info = Color(0xFF2A9D8F);

  static ThemeData lightTheme() {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundLight,
      fontFamily: 'Poppins',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w700),
        headlineSmall: TextStyle(color: textPrimary, fontWeight: FontWeight.w700),
        titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textSecondary),
        bodySmall: TextStyle(color: textLight),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: primaryColor,
        secondary: secondaryColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 14,
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      home: const EditProfileScreen(),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _editingUsername = false;
  bool _editingPhone = false;
  bool _editingAddress = false;
  bool _editingEmail = false;

  UserModel? _currentUser;
  bool _isLoading = true;
  bool _loadError = false;
  String _errorMessage = '';

  final _formKey = GlobalKey<FormState>(); 

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _animationController = AnimationController(
      vsync: this,

      duration: const Duration(milliseconds: 800),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
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
      final user = await AuthService().getUserProfile();

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
          _errorMessage = 'Tidak dapat memuat profil. Data null.';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _loadError = true;
        _errorMessage = 'Error saat mengambil profil: $e';
      });
      print('Error saat mengambil profil: $e');
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 1.5),
            ),
            padding: const EdgeInsets.all(5),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
          : _loadError
              ? _buildErrorView()
              : FadeTransition(
                  opacity: _fadeInAnimation,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/images/editprofil.png',
                              height: 180,
                              fit: BoxFit.fitHeight,
                              errorBuilder: (context, error, stackTrace) {
                                return SizedBox(
                                  height: 180,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _buildIllustrationPerson(
                                        const Color(0xFF8B6E4E),
                                        const Color(0xFFE5BEA0),
                                      ),
                                      const SizedBox(width: 20),
                                      _buildIllustrationPerson(
                                        const Color(0xFF424242),
                                        const Color(0xFFEADAC5),
                                      ),
                                    ],
                                  ),
                                );
                              },
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
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                _buildEditableTextField(
                                  controller: _usernameController,
                                  icon: const Icon(Icons.person_outline),
                                  hint: 'Username',
                                  labelText: 'Username',
                                  isEditing: _editingUsername,
                                  onEditTap: () {
                                    setState(() {
                                      _editingUsername = !_editingUsername;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Username harus diisi';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                
                                _buildEditableTextField(
                                  controller: _phoneController,
                                  icon: const Icon(Icons.phone_outlined),
                                  hint: 'No.telp',
                                  labelText: 'No. Telepon',
                                  isEditing: _editingPhone,
                                  onEditTap: () {
                                    setState(() {
                                      _editingPhone = !_editingPhone;
                                    });
                                  },
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Nomor telepon harus diisi';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                
                                _buildEditableTextField(
                                  controller: _addressController,
                                  icon: const Icon(Icons.location_on_outlined),
                                  hint: 'Alamat',
                                  labelText: 'Alamat',
                                  isEditing: _editingAddress,
                                  onEditTap: () {
                                    setState(() {
                                      _editingAddress = !_editingAddress;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Alamat harus diisi';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                
                                _buildEditableTextField(
                                  controller: _emailController,
                                  icon: const Icon(Icons.email_outlined),
                                  hint: 'Email',
                                  labelText: 'Email',
                                  isEditing: _editingEmail,
                                  onEditTap: () {
                                    setState(() {
                                      _editingEmail = !_editingEmail;
                                    });
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Email harus diisi';
                                    }
                                    if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(value)) {
                                      return 'Email tidak valid';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 32),
                                
                                SlideTransition(
                                  position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
                                    CurvedAnimation(
                                      parent: _animationController,
                                      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
                                    ),
                                  ),
                                  child: PrimaryButton(
                                    label: 'Selesai',
                                    onPressed: () {
                                      if (_formKey.currentState?.validate() ?? false) {
                                        _saveProfile();
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppTheme.error,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Terjadi Kesalahan',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
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

  Widget _buildIllustrationPerson(Color color1, Color color2) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildEditableTextField({
    required TextEditingController controller,
    required Icon icon,
    required String hint,
    required String labelText,
    required bool isEditing,
    required VoidCallback onEditTap,
    required String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Stack(
      children: [
        CustomTextField(
          controller: controller,
          icon: icon,
          hint: hint,
          labelText: labelText,  // Tambahkan parameter labelText
          keyboardType: keyboardType,
          validator: validator,
          enabled: isEditing,
          readOnly: !isEditing,
        ),
        Positioned(
          right: 12,
          top: 0,
          bottom: 0,
          child: Center(
            child: IconButton(
              icon: Icon(
                isEditing ? Icons.check : Icons.edit,
                color: AppTheme.primaryColor,
                size: 20,
              ),
              onPressed: onEditTap,
            ),
          ),
        ),
      ],
    );
  }

  void _saveProfile() {
    if (_currentUser == null) {
      _currentUser = UserModel(
        id: 0, 
        username: _usernameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        role: '',
      );
    } else {
      _currentUser = UserModel(
        id: _currentUser!.id,
        username: _usernameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        role: _currentUser!.role,
      );
    }

    setState(() {
      _editingUsername = false;
      _editingPhone = false;
      _editingAddress = false;
      _editingEmail = false;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            color: AppTheme.primaryColor,
          ),
        );
      },
    );

    AuthService().updateUserProfile(_currentUser!).then((success) {
      Navigator.pop(context); 
      if (success) {
        _showSuccessDialog();
      } else {
        _showErrorDialog();
      }
    }).catchError((error) {
      Navigator.pop(context);
      _showErrorDialog('Error: $error');
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Profil Berhasil Diperbarui'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog([String errorMessage = 'Terjadi kesalahan.']) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Gagal Memperbarui Profil'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}