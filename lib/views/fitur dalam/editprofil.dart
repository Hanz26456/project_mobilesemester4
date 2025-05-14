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

  final _formKey = GlobalKey<FormState>(); 

  @override
  void initState() {
    super.initState();
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
    
    _loadUserProfile();  // Memanggil fungsi untuk memuat profil
  }

  Future<void> _loadUserProfile() async {
    final user = await AuthService().getUserProfile();

    if (user != null) {
      setState(() {
        _usernameController.text = user.username;
        _phoneController.text = user.phone;
        _addressController.text = user.address;
        _emailController.text = user.email;
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
      body: FadeTransition(
        opacity: _fadeInAnimation,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Illustration
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

                // Title and Subtitle
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
                      CustomTextField(
                        controller: _usernameController,
                        icon: const Icon(Icons.person_outline),
                        hint: 'Username',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username harus diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _phoneController,
                        icon: const Icon(Icons.phone_outlined),
                        hint: 'No.telp',
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nomor telepon harus diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _addressController,
                        icon: const Icon(Icons.location_on_outlined),
                        hint: 'Alamat',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Alamat harus diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _emailController,
                        icon: const Icon(Icons.email_outlined),
                        hint: 'Email',
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

  void _saveProfile() {
    final updatedUser = UserModel(
      id: 0, // Ganti dengan ID yang sesuai
      username: _usernameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      role: '', // Jika Anda ingin menambahkan role
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF2A9D8F), // AppTheme.primaryColor
          ),
        );
      },
    );

    AuthService().updateUserProfile(updatedUser).then((success) {
      Navigator.pop(context); // Tutup loading dialog
      if (success) {
        _showSuccessDialog();
      } else {
        _showErrorDialog();
      }
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Color(0xFF2A9D8F), size: 28),
              SizedBox(width: 8),
              Text('Sukses!'),
            ],
          ),
          content: const Text('Profil Anda berhasil diperbarui.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK', style: TextStyle(color: Color(0xFF2A9D8F))),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.error, color: Color(0xFFE76F51), size: 28),
              SizedBox(width: 8),
              Text('Error'),
            ],
          ),
          content: const Text('Gagal memperbarui profil. Silakan coba lagi.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK', style: TextStyle(color: Color(0xFFE76F51))),
            ),
          ],
        );
      },
    );
  }
}
