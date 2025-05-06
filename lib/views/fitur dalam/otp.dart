import 'package:flutter/material.dart';
import 'passwordbaru.dart';
import 'package:flutter/services.dart';

class otpPage extends StatefulWidget {
  final String email; // Menyimpan email yang dikirimkan
  final String otpFromServer;

  const otpPage({super.key, required this.email, required this.otpFromServer});

  @override
  State<otpPage> createState() => _otpPageState();
}

class _otpPageState extends State<otpPage> {
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  void _submitOtp() {
    print('Tombol Verifikasi ditekan');
    final otp = _controllers.map((c) => c.text).join();
    print('OTP yang dimasukkan: $otp');

    // Cek apakah OTP yang diterima dari server sudah benar
    if (widget.otpFromServer.isEmpty) {
      print('OTP dari server tidak diterima');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menerima OTP dari server')),
      );
      return;
    }

    // Validasi OTP 6 digit
    if (otp.length == 6) {
      if (otp == widget.otpFromServer) {
        print('OTP benar, pindah ke PasswordbaruPage');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PasswordbaruPage(email: widget.email),
          ),
        );
      } else {
        print('OTP salah');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kode OTP salah')),
        );
      }
    } else {
      print('OTP tidak lengkap');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kode OTP harus 6 digit')),
      );
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 20),

              // Gambar email
              Center(
                child: Image.asset('assets/images/email.png', height: 120),
              ),
              const SizedBox(height: 24),

              const Text(
                'Verifikasi Emailmu',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Masukkan kode OTP nya bossku',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 24),

              // Kotak OTP manual
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 40,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly, // ⬅️ Hanya izinkan angka
                      ],
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      decoration: const InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                        }
                      },
                    ),
                  );
                }),
              ),

              const SizedBox(height: 24),

              // Tombol verifikasi
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D9C73),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _submitOtp,
                  child: const Text(
                    'Verifikasi',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
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
