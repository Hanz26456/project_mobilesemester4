import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'config.dart';

class UploadProfileService {
  static Future<dynamic> uploadProfilePhoto(
    File? imageFile,
    String? token,
    String userId,
  ) async {
    if (imageFile == null || token == null || userId.isEmpty) {
      print("❗ Data tidak lengkap. Upload dibatalkan.");
      return null;
    }
    // print(imageFile);

    final uri = Uri.parse('${Config.baseUrl}/upload-profile-photo');
    final request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';
    request.fields['user_id'] = userId;

    request.files.add(
      await http.MultipartFile.fromPath(
        'photo',
        imageFile.path,
        filename: basename(imageFile.path),
      ),
    );

    try {
      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();
      final fullResponse = http.Response(
        responseBody,
        streamedResponse.statusCode,
        headers: streamedResponse.headers,
      );
      print(fullResponse.body);

      return fullResponse;
    } catch (e) {
      print('❌ Terjadi kesalahan: $e');
      return null;
    }
  }
}
