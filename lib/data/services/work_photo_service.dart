import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/work_photo_model.dart';
import '../../data/services/config.dart';

class WorkPhotoService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: Config.baseUrl,
    headers: {
      'Accept': 'application/json',
    },
  ));

  // Fungsi untuk mengompres file gambar
  Future<File> compressImage(File file, {int quality = 70}) async {
    final dir = await getTemporaryDirectory();
    final targetPath = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
      // Batasi ukuran maksimum (resolusi)
      minWidth: 1024,
      minHeight: 1024,
    );
    
    // Periksa ukuran hasil kompresi (dalam KB)
    final compressedSize = await result!.length() / 1024;
    print('Compressed image size: ${compressedSize.toStringAsFixed(2)} KB');
    
    // Jika masih > 2000KB, kompres lagi dengan kualitas lebih rendah
    if (compressedSize > 2000) {
      return compressImage(File(result.path), quality: quality - 10);
    }
    
    return File(result.path);
  }

  Future<dynamic> uploadPhoto({
    required int orderId,
    XFile? photoBefore,
    XFile? photoAfter,
    String? catatan,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      
      if (token.isEmpty) {
        throw Exception('Token tidak ditemukan, silakan login kembali');
      }
      
      // Kompres foto jika ada
      File? compressedBefore;
      File? compressedAfter;
      
      if (photoBefore != null) {
        print('Original photoBefore size: ${File(photoBefore.path).lengthSync() / 1024} KB');
        compressedBefore = await compressImage(File(photoBefore.path));
      }
      
      if (photoAfter != null) {
        print('Original photoAfter size: ${File(photoAfter.path).lengthSync() / 1024} KB');
        compressedAfter = await compressImage(File(photoAfter.path));
      }
      
      print('Uploading to: ${Config.baseUrl}/upload-image');
      print('Order ID: $orderId');
      print('Has photoBefore: ${photoBefore != null}');
      print('Has photoAfter: ${photoAfter != null}');
      
      final formData = FormData.fromMap({
        'order_id': orderId.toString(),
        if (compressedBefore != null)
          'photo_before': await MultipartFile.fromFile(
            compressedBefore.path,
            filename: 'before_${DateTime.now().millisecondsSinceEpoch}.jpg',
          ),
        if (compressedAfter != null)
          'photo_after': await MultipartFile.fromFile(
            compressedAfter.path,
            filename: 'after_${DateTime.now().millisecondsSinceEpoch}.jpg',
          ),
        if (catatan != null && catatan.isNotEmpty) 'catatan': catatan,
      });
      
      final response = await _dio.post(
        '/upload-image',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return "berhasil";
        // WorkPhoto.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Gagal upload foto kerja');
      }
    } catch (e) {
      print('Upload error detail: $e');
      if (e is DioException) {
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      }
      throw e;
    }
  }
}