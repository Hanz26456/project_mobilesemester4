import 'package:flutter/material.dart';
import '../../data/services/history_service.dart'; // ganti dengan file tempat kamu taruh fetchUserOrders
import '../../data/models/order_response.dart';   // file model OrderResponse kamu
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<OrderResponse>> futureOrders;

  int? userId;

  @override
  void initState() {
    super.initState();
    loadUserAndFetch();
  }

  void loadUserAndFetch() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUserId = prefs.getInt('user_id');
    setState(() {
      userId = savedUserId;
      futureOrders = fetchUserOrders(savedUserId ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: userId == null
            ? const Center(child: CircularProgressIndicator())
            : FutureBuilder<List<OrderResponse>>(
                future: futureOrders,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Gagal memuat riwayat'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Tidak ada riwayat pesanan.'));
                  }

                  final orders = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final firstService = order.orderDetails.isNotEmpty
                          ? order.orderDetails.first.service.name
                          : 'Layanan Tidak Diketahui';

                      return Column(
                        children: [
                          _buildHistoryItem(
                            context,
                            firstService,
                            '${order.tanggalPemesanan}, 10.45',
                            order.tanggalPemesanan,
                            order.status,
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  );
                },
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
        statusColor = Colors.blue.shade100;
        textColor = Colors.blue.shade700;
        break;
      case 'pending':
        statusColor = Colors.yellow.shade100;
        textColor = Colors.orange.shade700;
        break;
      case 'done':
        statusColor = Colors.green.shade100;
        textColor = Colors.green.shade700;
        break;
      default:
        statusColor = Colors.grey.shade100;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
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
          // Service details
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

          // Date and Status
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
