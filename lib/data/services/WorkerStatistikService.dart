import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/worker_statistik.dart';
import '../services/config.dart';

class WorkerStatistikService {
  Future<WorkerStatistik> fetchStatistik() async {
    print('=== Fetching statistik ===');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('Token: ${token != null ? 'Ada' : 'Tidak ada'}');

    if (token == null) {
      throw Exception('Token tidak ditemukan. Harap login ulang.');
    }

    final url = Uri.parse('${Config.baseUrl}/worker/statistik');
    print('URL: $url');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print('Parsed JSON: $jsonData');
      return WorkerStatistik.fromJson(jsonData);
    } else {
      throw Exception('Gagal memuat statistik pekerja. Status: ${response.statusCode}');
    }
  }
}