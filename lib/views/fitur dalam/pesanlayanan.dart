import 'package:flutter/material.dart';
import '../../widgets/primary_button.dart';
import '../../data/models/order_request.dart';
import '../../data/services/order_service.dart';

class ServiceOrderSummary extends StatefulWidget {
  final int userId;
  final int serviceId;
  final int price;
  final int initialQuantity;

  const ServiceOrderSummary({
    super.key,
    required this.userId,
    required this.serviceId,
    required this.price,
    this.initialQuantity = 1, // default quantity
  });

  @override
  State<ServiceOrderSummary> createState() => _ServiceOrderSummaryState();
}

class _ServiceOrderSummaryState extends State<ServiceOrderSummary> {
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  int _quantity = 1;
  String _paymentMethod = 'tunai'; // Default payment method

  DateTime _selectedDate = DateTime.now();
  String _formattedDate = 'Pilih tanggal';

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity;
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
      _formattedDate = "${date.day} ${_getMonthName(date.month)} ${date.year}";
    });
  }

  String _getMonthName(int month) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
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

  Future<void> _submitOrder() async {
    if (_quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Jumlah layanan tidak valid")),
      );
      return;
    }

    final order = OrderRequest(
      userId: widget.userId,
      tanggalPemesanan: _selectedDate.toIso8601String(),
      metodePembayaran: _paymentMethod, // Menggunakan metode pembayaran yang dipilih
      services: [
        OrderServiceItem(
          serviceId: widget.serviceId,
          quantity: _quantity,
          price: widget.price,
        )
      ],
    );

    final success = await OrderService.createOrder(order);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pemesanan berhasil!")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal melakukan pemesanan")),
      );
    }
  }

  // Method untuk memilih metode pembayaran
  Widget _buildPaymentMethodSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Metode Pembayaran',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          DropdownButton<String>(
            value: _paymentMethod,
            items: const [
              DropdownMenuItem<String>(
                value: 'tunai',
                child: Text('Tunai'),
              ),
              DropdownMenuItem<String>(
                value: 'non-tunai',
                child: Text('Non-Tunai'),
              ),
            ],
            onChanged: (String? newValue) {
              setState(() {
                _paymentMethod = newValue!;
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pesan Layanan',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDatePicker(context),
            _buildDivider(),
            _buildQuantitySelector(),
            _buildDivider(),
            _buildPaymentMethodSelector(), // Menambahkan dropdown untuk metode pembayaran
            _buildDivider(),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ringkasan Ongkosan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Rp. ${widget.price * _quantity}',  // Total harga berdasarkan quantity
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Spacer(),
            PrimaryButton(
              label: 'Lakukan Pemesanan',
              onPressed: _submitOrder,
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
                const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Jumlah',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if (_quantity > 1) _quantity--;
                  });
                },
              ),
              Text(
                _quantity.toString(),
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    _quantity++;
                  });
                },
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
