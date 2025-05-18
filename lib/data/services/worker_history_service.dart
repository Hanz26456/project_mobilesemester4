import 'package:dio/dio.dart';
import '../services/config.dart';
import '../models/WorkerOrderHistoryModel.dart';

class WorkerHistoryService {
  final Dio _dio = Dio(BaseOptions(baseUrl: Config.baseUrl));

  Future<List<WorkerOrderHistory>> getWorkerHistory(int workerId) async {
    try {
      final response = await _dio.post(
        '/get-worker-history',
        data: {'worker_id': workerId},
      );

      if (response.data['status'] == true) {
        List data = response.data['data'];
        return data.map((e) => WorkerOrderHistory.fromJson(e)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Gagal mengambil data');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat memuat riwayat pekerjaan: $e');
    }
  }
}
