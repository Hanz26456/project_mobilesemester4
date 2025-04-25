import 'package:flutter/material.dart';
// Import your custom button
import '../../widgets/primary_button.dart';

class ServiceOrderSummary extends StatelessWidget {
  const ServiceOrderSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          'Pesan Layanan',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order details sections
            _buildOrderDetailRow(
              title: 'Tanggal',
              value: '20 April 2025',
              showArrow: true,
            ),
            _buildDivider(),
            _buildOrderDetailRow(title: 'Waktu', value: 'Sore hari'),
            _buildDivider(),
            _buildOrderDetailRow(
              title: 'Alamat',
              value: 'Jl. Belok kiri, No 56 Bondowoso',
            ),
            _buildDivider(),
            _buildOrderDetailRow(title: 'Catatan', value: 'Cepetan bang'),
            _buildDivider(),

            const SizedBox(height: 24),

            // Price summary section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Ringkasan Ongkosan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Rp. 150.000',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Modified: Use label instead of text
            PrimaryButton(
              label: 'Lanjut Pembayaran',
              onPressed: () {
                // Handle button press
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetailRow({
    required String title,
    required String value,
    bool showArrow = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              if (showArrow)
                const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE));
  }
}
