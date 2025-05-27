import 'package:flutter/material.dart';
import 'package:home_service/data/services/session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/services/history_service.dart';
import '../../data/models/order_response.dart';
import '../fitur dalam/detailpesanan.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Future<List<OrderResponse>>? futureOrders;
  int? userId;

  @override
  void initState() {
    super.initState();
    loadUserAndFetch();
  }

  void loadUserAndFetch() async {
  final user = await Sessionn.user();
  final token = user['token'];
  final savedUserId = user['user_id'];

  if (savedUserId != null) {
    setState(() {
      userId = savedUserId;
      futureOrders = fetchUserOrders(savedUserId).catchError((e) {
        print('❌ Error fetchUserOrders: $e');
        return <OrderResponse>[];
      });
    });
  } else {
    print('⚠️ user_id masih null');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: userId == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        'Riwayat',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<List<OrderResponse>>(
                      future: futureOrders,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(child: Text('Gagal memuat riwayat.'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('Tidak ada riwayat pesanan.'));
                        }

                        final orders = snapshot.data!;
                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            final order = orders[index];

                            final allServices = order.orderDetails
                                .map((detail) => detail.service.name)
                                .join(', ');

                            final dateTime = DateTime.parse(order.tanggalPemesanan);
                            final tanggal =
                                '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}';
                            final jam =
                                '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderDetailsScreen(order: order),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  _buildHistoryItem(
                                    context,
                                    allServices,
                                    '$tanggal, $jam',
                                    tanggal,
                                    order.status,
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildHistoryItem(
    BuildContext context,
    String title,
    String dateTime,
    String orderDate,
    String status,
  ) {
    Color statusColor;
    Color textColor = Colors.black;

    switch (status.toLowerCase()) {
      case 'process':
      case 'proses':
        statusColor = Colors.blue.shade100;
        textColor = Colors.blue.shade700;
        break;
      case 'pending':
        statusColor = Colors.yellow.shade100;
        textColor = Colors.orange.shade700;
        break;
      case 'done':
      case 'selesai':
        statusColor = Colors.green.shade100;
        textColor = Colors.green.shade700;
        break;
      default:
        statusColor = Colors.grey.shade200;
        textColor = Colors.black54;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  dateTime,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                orderDate,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
