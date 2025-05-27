import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../data/models/WorkerOrderHistoryModel.dart';
import '../../data/services/work_photo_service.dart';

class UploadPhotoScreen extends StatefulWidget {
  final WorkerOrderHistory order;
  const UploadPhotoScreen({super.key, required this.order});

  @override
  State<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> with SingleTickerProviderStateMixin {
  XFile? photoBefore;
  XFile? photoAfter;
  final _noteController = TextEditingController();
  final _picker = ImagePicker();
  final WorkPhotoService _uploadService = WorkPhotoService();
  late TabController _tabController;
  bool _isLoading = false;
  
  // Definisi palette warna modern
  final Color primaryColor = const Color.fromARGB(255, 68, 178, 13);  // Indigo
  final Color accentColor = const Color.fromARGB(255, 68, 178, 13);  // Deep Orange
  final Color backgroundColor = const Color(0xFFF5F7FA);
  final Color cardColor = Colors.white;
  final Color textDarkColor = const Color(0xFF2D3748);
  final Color textLightColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isBefore) async {
    final picked = await showModalBottomSheet<XFile?>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Pilih Sumber Foto',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textDarkColor,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _imageSourceOption(
                    icon: Icons.camera_alt_rounded,
                    label: 'Kamera',
                    onTap: () async {
                      final image = await _picker.pickImage(source: ImageSource.camera);
                      Navigator.pop(context, image);
                    },
                  ),
                  _imageSourceOption(
                    icon: Icons.photo_library_rounded,
                    label: 'Galeri',
                    onTap: () async {
                      final image = await _picker.pickImage(source: ImageSource.gallery);
                      Navigator.pop(context, image);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        if (isBefore) {
          photoBefore = picked;
        } else {
          photoAfter = picked;
        }
      });
    }
  }

  Widget _imageSourceOption({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 36, color: primaryColor),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: textDarkColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _upload() async {
    if (photoBefore == null && photoAfter == null) {
      _showNotification('Upload minimal 1 foto.', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _uploadService.uploadPhoto(
        orderId: widget.order.id,
        photoBefore: photoBefore,
        photoAfter: photoAfter,
        catatan: _noteController.text,
      );

      setState(() {
        _isLoading = false;
      });

      _showNotification('Foto berhasil diupload');
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Upload error: $e');
      _showNotification('Terjadi kesalahan saat upload: $e', isError: true);
    }
  }

  void _showNotification(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        action: SnackBarAction(
          label: 'OK',
          textColor: textLightColor,
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _buildPhotoCard(bool isBefore, XFile? photo) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (photo != null)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.file(
                    File(photo.path),
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (isBefore) {
                          photoBefore = null;
                        } else {
                          photoAfter = null;
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isBefore ? Icons.photo_camera_back : Icons.photo_camera_front,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isBefore ? 'Foto Sebelum' : 'Foto Sesudah',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          else
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isBefore ? Icons.photo_camera_back : Icons.photo_camera_front,
                        color: primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isBefore ? 'Foto Sebelum' : 'Foto Sesudah',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textDarkColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => _pickImage(isBefore),
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(12),
                      color: Colors.grey.shade300,
                      strokeWidth: 2,
                      dashPattern: const [6, 4],
                      child: Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.add_a_photo_rounded,
                                size: 36,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Ketuk untuk ambil foto',
                              style: TextStyle(
                                color: textDarkColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'JPG, PNG, atau HEIC',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (photo != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: () => _pickImage(isBefore),
                icon: const Icon(Icons.repeat_rounded, size: 20),
                label: const Text('Ganti Foto'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: textLightColor,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOrderInfo() {
    final serviceName = widget.order.orderDetails.isNotEmpty
        ? widget.order.orderDetails[0].service.name
        : '-';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.home_repair_service_rounded, color: primaryColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Detail Layanan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textDarkColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _infoRow(Icons.work_rounded, 'Layanan', serviceName),
          _infoRow(Icons.calendar_today_rounded, 'Tanggal', widget.order.tanggalPemesanan),
          _infoRow(Icons.payments_rounded, 'Pembayaran', 'Rp${widget.order.totalPembayaran}'),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: textDarkColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoteSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.note_alt_rounded, color: primaryColor, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'Catatan Pekerjaan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textDarkColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                hintText: 'Tambahkan catatan pekerjaan...',
                filled: true,
                fillColor: backgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor, width: 1.5),
                ),
              ),
              maxLines: 4,
              style: TextStyle(color: textDarkColor),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Upload Foto Pekerjaan'),
        centerTitle: true,
        backgroundColor: cardColor,
        elevation: 0,
        foregroundColor: textDarkColor,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textDarkColor,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: () {
              // Show help info
              _showNotification('Unggah minimal 1 foto untuk melengkapi pekerjaan');
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: primaryColor,
          unselectedLabelColor: Colors.grey.shade600,
          indicatorColor: primaryColor,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Upload Foto'),
            Tab(text: 'Catatan'),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Foto
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOrderInfo(),
                      _buildPhotoCard(true, photoBefore),
                      _buildPhotoCard(false, photoAfter),
                    ],
                  ),
                ),
                
                // Tab 2: Catatan
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOrderInfo(),
                      _buildNoteSection(),
                    ],
                  ),
                ),
              ],
            ),
            
            // Loading overlay
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: primaryColor),
                        const SizedBox(height: 16),
                        const Text(
                          'Mengupload...',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _upload,
                icon: const Icon(Icons.cloud_upload_rounded),
                label: const Text('Upload Foto'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: textLightColor,
                  disabledBackgroundColor: Colors.grey.shade400,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}