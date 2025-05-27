import 'package:flutter/material.dart';
import 'package:home_service/data/services/session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/WorkerOrderHistoryModel.dart';
import '../../data/services/worker_history_service.dart';
import '../pekerja/upload_foto.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  List<WorkerOrderHistory> _riwayat = [];
  bool _loading = true;
  final _service = WorkerHistoryService();

  @override
  void initState() {
    super.initState();
    _loadRiwayat();
  }

  Future<void> _loadRiwayat() async {
    setState(() => _loading = true);
    try {
      // final prefs = await SharedPreferences.getInstance();
      final user = await Sessionn.user();
      // final prefs = await SharedPreferences.getInstance();
      // final token = user['token'];
      final workerId = user['user_id'] ?? 0;
      if (workerId == 0) throw Exception('User belum login');
      final data = await _service.getWorkerHistory(workerId);
      setState(() {
        _riwayat = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      debugPrint('Error load riwayat: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memuat riwayat pekerjaan')),
      );
    }
  }

  List<WorkerOrderHistory> get _tabKiriRiwayat =>
      _riwayat
          .where(
            (e) => e.status == 'proses' || e.status == 'selesai_pengerjaan',
          )
          .toList();

  List<WorkerOrderHistory> get _tabKananRiwayat =>
      _riwayat
          .where((e) => e.status == 'pending_setoran' || e.status == 'selesai')
          .toList();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: Center(
                  child: Text(
                    'Pekerjaan Saya',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue,
                tabs: [
                  Tab(text: 'Proses & Selesai Pengerjaan'),
                  Tab(text: 'Pending Setoran & Selesai'),
                ],
              ),
              Expanded(
                child:
                    _loading
                        ? const Center(child: CircularProgressIndicator())
                        : TabBarView(
                          children: [
                            _buildRiwayatList(_tabKiriRiwayat),
                            _buildRiwayatList(_tabKananRiwayat),
                          ],
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRiwayatList(List<WorkerOrderHistory> list) {
    if (list.isEmpty) {
      return const Center(child: Text('Tidak ada data.'));
    }

    return RefreshIndicator(
      onRefresh: _loadRiwayat,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        itemCount: list.length,
        itemBuilder: (context, idx) => _buildRiwayatItem(list[idx]),
      ),
    );
  }

  Widget _buildRiwayatItem(WorkerOrderHistory item) {
    final serviceName =
        item.orderDetails.isNotEmpty
            ? item.orderDetails[0].service.name
            : 'Layanan';

    return GestureDetector(
      onTap:
          item.status == 'proses'
              ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UploadPhotoScreen(order: item),
                  ),
                ).then((_) => _loadRiwayat());
              }
              : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service: $serviceName',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('Tanggal Pesanan: ${_formatDateTime(item.tanggalPemesanan)}'),
            Text('Total Pembayaran: Rp${item.totalPembayaran}'),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: _buildStatusBadge(item.status),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg;
    switch (status) {
      case 'proses':
        bg = const Color(0xFFB8E8FC);
        break;
      case 'pending_setoran':
        bg = const Color(0xFFFFF9C4);
        break;
      case 'selesai':
      case 'selesai_pengerjaan':
        bg = const Color(0xFFD5ECC2);
        break;
      default:
        bg = Colors.grey.shade200;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.replaceAll('_', ' ').toUpperCase(),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black54,
        ),
      ),
    );
  }

  String _formatDateTime(String ts) {
    final d = DateTime.parse(ts).toLocal();
    return '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}, '
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }
}
