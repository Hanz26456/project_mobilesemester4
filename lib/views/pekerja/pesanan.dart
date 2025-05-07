import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:timeline_tile/timeline_tile.dart';

class StatusPekerja extends StatefulWidget {
  const StatusPekerja({super.key});

  @override
  State<StatusPekerja> createState() => _StatusPekerjaState();
}

class _StatusPekerjaState extends State<StatusPekerja> {
  File? fotoSebelum;
  File? fotoSesudah;

  Future<void> pickImage(bool isBefore) async {
    final picker = ImagePicker();
    final result = await picker.pickImage(source: ImageSource.camera);

    if (result != null) {
      setState(() {
        if (isBefore) {
          fotoSebelum = File(result.path);
        } else {
          fotoSesudah = File(result.path);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progres Pekerjaan'),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        children: [
          _buildTimelineTile(
            title: "Foto Sebelum Pekerjaan",
            time: "Ambil gambar kondisi awal",
            imageFile: fotoSebelum,
            onUpload: () => pickImage(true),
          ),
          _buildTimelineTile(
            title: "Foto Setelah Pekerjaan",
            time: "Ambil gambar hasil akhir",
            imageFile: fotoSesudah,
            onUpload: () => pickImage(false),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineTile({
    required String title,
    required String time,
    required File? imageFile,
    required VoidCallback onUpload,
    bool isLast = false,
  }) {
    return TimelineTile(
      alignment: TimelineAlign.start,
      isFirst: false,
      isLast: isLast,
      indicatorStyle: const IndicatorStyle(
        width: 20,
        color: Colors.teal,
      ),
      beforeLineStyle: const LineStyle(
        color: Colors.teal,
        thickness: 3,
      ),
      endChild: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(time),
            const SizedBox(height: 8),
            imageFile != null
                ? Image.file(imageFile, height: 150)
                : const Text('Belum ada foto'),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: onUpload,
              icon: const Icon(Icons.camera_alt),
              label: const Text("Ambil Foto"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            ),
          ],
        ),
      ),
    );
  }
}
