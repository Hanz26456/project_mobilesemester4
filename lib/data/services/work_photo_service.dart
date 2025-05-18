import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/work_photo_model.dart';
import '../../data/services/config.dart'; // pastikan baseUrl di sini

class WorkPhotoService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: Config.baseUrl,
    headers: {
      'Accept': 'application/json',
    },
  ));

  Future<WorkPhoto> uploadPhoto({
    required int orderId,
    XFile? photoBefore,
    XFile? photoAfter,
    String? catatan,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final formData = FormData.fromMap({
      'order_id': orderId,
      if (photoBefore != null)
        'photo_before': await MultipartFile.fromFile(photoBefore.path, filename: photoBefore.name),
      if (photoAfter != null)
        'photo_after': await MultipartFile.fromFile(photoAfter.path, filename: photoAfter.name),
      if (catatan != null) 'catatan': catatan,
    });

    final response = await _dio.post(
       '/upload-image',
      data: formData,
      options: Options(headers: {
        'Authorization': 'Bearer $token',
      }),
    );

    if (response.statusCode == 200) {
      return WorkPhoto.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? 'Gagal upload foto kerja');
    }
  }
}

