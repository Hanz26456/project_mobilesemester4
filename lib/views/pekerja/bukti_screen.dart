import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';

class BuktiScreen extends StatefulWidget {
  const BuktiScreen({super.key});

  @override
  State<BuktiScreen> createState() => _BuktiScreenState();
}

class _BuktiScreenState extends State<BuktiScreen> {
  File? _beforeImage;
  File? _afterImage;
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  Future<void> _getImage(bool isBefore) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Pilih Sumber Gambar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, size: 24),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3D8361).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.photo_camera,
                      color: Color(0xFF3D8361),
                    ),
                  ),
                  title: const Text('Ambil Foto dengan Kamera'),
                  subtitle: const Text('Gunakan kamera untuk mengambil foto'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera, isBefore);
                  },
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3D8361).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.photo_library,
                      color: Color(0xFF3D8361),
                    ),
                  ),
                  title: const Text('Pilih dari Galeri'),
                  subtitle: const Text('Pilih foto dari galeri Anda'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery, isBefore);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source, bool isBefore) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1000,
      );

      if (image != null) {
        setState(() {
          if (isBefore) {
            _beforeImage = File(image.path);
          } else {
            _afterImage = File(image.path);
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error mengambil gambar: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Future<void> _submitEvidence() async {
    if (_beforeImage == null || _afterImage == null) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Text('Bukti berhasil dikirim!'),
              ],
            ),
            backgroundColor: const Color(0xFF3D8361),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        setState(() {
          _beforeImage = null;
          _afterImage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 10),
                Text('Gagal mengirim bukti: $e'),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black54, width: 1.5),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.black54, size: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: const Text(
          'Bukti Pekerjaan',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3D8361).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/upload_illustration.png',
                      height: 120,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            color: const Color(0xFF3D8361).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cloud_upload_outlined,
                                size: 60,
                                color: const Color(0xFF3D8361),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Kirim Bukti Pekerjaan',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3D8361),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Unggah foto kondisi sebelum dan sesudah sebagai bukti pekerjaan Anda telah selesai.',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 30),
                _buildImageSection(
                  title: 'Foto Sebelum',
                  subtitle: 'Kondisi sebelum pekerjaan dimulai',
                  image: _beforeImage,
                  onTap: () => _getImage(true),
                ),
                const SizedBox(height: 24),
                _buildImageSection(
                  title: 'Foto Sesudah',
                  subtitle: 'Kondisi setelah pekerjaan selesai',
                  image: _afterImage,
                  onTap: () => _getImage(false),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: (_beforeImage != null &&
                            _afterImage != null &&
                            !_isSubmitting)
                        ? _submitEvidence
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3D8361),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: _isSubmitting
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Mengirim...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.upload_file, size: 22),
                              const SizedBox(width: 10),
                              Text(
                                'Kirim Bukti',
                                style: TextStyle(
                                  color: (_beforeImage != null && _afterImage != null)
                                      ? Colors.white
                                      : Colors.grey.shade400,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection({
    required String title,
    required String subtitle,
    required File? image,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
        border: Border.all(
          color: image != null
              ? const Color(0xFF3D8361).withOpacity(0.3)
              : Colors.grey.shade200,
          width: image != null ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3D8361),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              if (image != null)
                TextButton.icon(
                  onPressed: onTap,
                  icon: const Icon(
                    Icons.refresh,
                    size: 16,
                    color: Color(0xFF3D8361),
                  ),
                  label: const Text(
                    'Ganti Foto',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF3D8361),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: const Color(0xFF3D8361).withOpacity(0.3),
                      ),
                    ),
                    backgroundColor: const Color(0xFF3D8361).withOpacity(0.1),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onTap,
            child: image != null
                ? Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.file(
                            image,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            right: 10,
                            top: 10,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3D8361),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Foto Siap',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    dashPattern: const [8, 4],
                    color: Colors.grey.shade400,
                    strokeWidth: 1.5,
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add_a_photo_outlined,
                              size: 40,
                              color: const Color(0xFF3D8361).withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3D8361).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Text(
                              'Tekan untuk mengambil foto',
                              style: TextStyle(
                                color: Color(0xFF3D8361),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}