import 'package:flutter/material.dart';

class RiwayatScreen extends StatelessWidget {
  const RiwayatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Contoh data riwayat
    final List<Map<String, dynamic>> riwayatItems = [
      {
        'title': 'AC Service',
        'date': '20 April 2025, 10.45',
        'orderDate': '10 April 2025',
        'status': 'Process'
      },
      {
        'title': 'Cleaning',
        'date': '20 April 2025, 10.45',
        'orderDate': '10 April 2025',
        'status': 'Pending'
      },
      {
        'title': 'tukang kebun',
        'date': '20 April 2025, 10.45',
        'orderDate': '10 April 2025',
        'status': 'Process'
      },
      {
        'title': 'ular dalam parit',
        'date': '20 April 2025, 10.45',
        'orderDate': '10 April 2025',
        'status': 'Done'
      },
    ];

    // Remove the Scaffold and use a Container as the root widget
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Custom AppBar (optional, can be removed if using dashboard's AppBar)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Riwayat',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            // ListView content
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                itemCount: riwayatItems.length,
                itemBuilder: (context, index) {
                  final item = riwayatItems[index];
                  return _buildRiwayatItem(item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiwayatItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left section with title and date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item['date'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            // Right section with order date and status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item['orderDate'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 8),
                _buildStatusBadge(item['status']),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor = Colors.black54;

    switch (status) {
      case 'Process':
        backgroundColor = const Color(0xFFB8E8FC); // Light blue
        break;
      case 'Pending':
        backgroundColor = const Color(0xFFFFF9C4); // Light yellow
        break;
      case 'Done':
        backgroundColor = const Color(0xFFD5ECC2); // Light green
        break;
      default:
        backgroundColor = Colors.grey.shade200;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}