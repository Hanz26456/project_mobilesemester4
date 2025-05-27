// Perbaikan pada JobStatusService dengan debugging tambahan

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/job_status.dart';
import '../services/config.dart';
import 'dart:math';

class JobStatusService {
  Future<JobStatus> fetchJobStatus(String token) async {
    final apiUrl = '${Config.baseUrl}/status-pekerjaan';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        try {
          final jsonData = jsonDecode(response.body);
          final jobStatus = JobStatus.fromJson(jsonData);
          return jobStatus;
        } catch (e) {
          print('JSON parse error: $e');
          // print('Response body: ${response.body}');
          return JobStatus(proses: 0, selesaiPengerjaan: 0, selesai: "0");
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception(
          'Gagal memuat data status pekerjaan: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Network error: $e');
      return JobStatus(proses: 0, selesaiPengerjaan: 0, selesai:"0");
    }
  }
}
