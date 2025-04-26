import 'package:flutter/material.dart';
// Import your custom button
import '../../widgets/primary_button.dart';

class ServiceOrderSummary extends StatefulWidget {
  const ServiceOrderSummary({Key? key}) : super(key: key);

  @override
  State<ServiceOrderSummary> createState() => _ServiceOrderSummaryState();
}

class _ServiceOrderSummaryState extends State<ServiceOrderSummary> {
  // Controllers for text fields
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  // Date related state
  DateTime _selectedDate = DateTime.now();
  String _formattedDate = 'Pilih tanggal';

  @override
  void initState() {
    super.initState();
    _formatDate(_selectedDate);
  }

  @override
  void dispose() {
    _timeController.dispose();
    _addressController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _formatDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      // Format the date as needed
      _formattedDate = "${date.day} ${_getMonthName(date.month)} ${date.year}";
    });
  }

  String _getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[month - 1];
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != _selectedDate) {
      _formatDate(picked);
    }
  }

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
            // Date picker
            _buildDatePicker(context),
            _buildDivider(),

            // Time input field
            _buildTextField(
              title: 'Waktu',
              controller: _timeController,
              hintText: 'Masukkan waktu (Pagi/Siang/Sore/Malam)',
            ),
            _buildDivider(),

            // Address input field
            _buildTextField(
              title: 'Alamat',
              controller: _addressController,
              hintText: 'Masukkan alamat lengkap',
            ),
            _buildDivider(),

            // Note input field
            _buildTextField(
              title: 'Catatan',
              controller: _noteController,
              hintText: 'Tambahkan catatan (opsional)',
            ),
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

  Widget _buildDatePicker(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Tanggal',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Row(
              children: [
                Text(
                  _formattedDate,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String title,
    required TextEditingController controller,
    required String hintText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                border: InputBorder.none,
              ),
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE));
  }
}
