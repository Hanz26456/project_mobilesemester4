import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header title
                const Center(
                  child: Text(
                    'Riwayat',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 24),

                // History Items
                _buildHistoryItem(
                  context,
                  'AC Service',
                  '20 April 2025, 10.45',
                  '10 April 2025',
                  'Process',
                ),
                const SizedBox(height: 16),

                _buildHistoryItem(
                  context,
                  'Cleaning',
                  '20 April 2025, 10.45',
                  '10 April 2025',
                  'Pending',
                ),
                const SizedBox(height: 16),

                _buildHistoryItem(
                  context,
                  'Tukang Kebun',
                  '20 April 2025, 10.45',
                  '10 April 2025',
                  'Process',
                ),
                const SizedBox(height: 16),

                _buildHistoryItem(
                  context,
                  'Ular Dalam Parit',
                  '20 April 2025, 10.45',
                  '10 April 2025',
                  'Done',
                ),

                // Dummy space at bottom for better scrolling experience
                const SizedBox(height: 24),
              ],
            ),
          ),
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
    // Menentukan warna status berdasarkan nilai status
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
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
