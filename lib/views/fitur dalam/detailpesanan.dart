import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:printing/printing.dart';         // untuk Printing.layoutPdf
import 'package:pdf/pdf.dart';                   // untuk PdfPageFormat
import 'package:pdf/widgets.dart' as pw;         // untuk pw.Document, pw.Text, dll
import '../../data/models/order_response.dart';
import '../../widgets/primary_button.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderResponse order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  String? userAddress;

  @override
  void initState() {
    super.initState();
    _loadUserAddress();
  }

  void _loadUserAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final alamat = prefs.getString('user_address');
    setState(() {
      userAddress = alamat ?? 'Alamat tidak tersedia';
    });
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    final dateTime = DateTime.parse(order.tanggalPemesanan);
    final tanggal =
        '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}';
    final jam =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

    final allServices = order.orderDetails
        .map((detail) => detail.service.name)
        .join(', ');

    final statusStyle = _getStatusStyle(order.status);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Pesanan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$tanggal, $jam',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusStyle['background'],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order.status,
                      style: TextStyle(
                        color: statusStyle['text'],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    allServices,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: const Text(
                        'Alamat',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        userAddress ?? 'Memuat alamat...',
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildPriceRow('Total', _calculateTotal(order).toString()),
                        const SizedBox(height: 8),
                        const Divider(),
                        const SizedBox(height: 8),
                        _buildPriceRow('Subtotal', _calculateTotal(order).toString()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: PrimaryButton(
              label: 'Cetak Bukti Transaksi',
              onPressed: _printTransactionReceipt,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        Text('Rp. $value', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ],
    );
  }

  int _calculateTotal(OrderResponse order) {
    return order.orderDetails.fold(0, (sum, detail) => sum + detail.subtotal);
  }

  Map<String, Color> _getStatusStyle(String status) {
    switch (status.toLowerCase()) {
      case 'proses':
      case 'process':
        return {
          'background': Colors.blue.shade100,
          'text': Colors.blue.shade700,
        };
      case 'pending':
        return {
          'background': Colors.yellow.shade100,
          'text': Colors.orange.shade700,
        };
      case 'selesai':
      case 'done':
        return {
          'background': Colors.green.shade100,
          'text': Colors.green.shade700,
        };
      case 'batal':
      case 'cancel':
        return {
          'background': Colors.red.shade100,
          'text': Colors.red.shade700,
        };
      default:
        return {
          'background': Colors.grey.shade200,
          'text': Colors.black54,
        };
    }
  }
Future<void> _printTransactionReceipt() async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Konfirmasi Cetak'),
      content: const Text('Apakah Anda ingin mencetak bukti transaksi ini?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Cetak'),
        ),
      ],
    ),
  );

  if (confirm != true) return;

  final pdf = pw.Document();
  final order = widget.order;

  final dateTime = DateTime.parse(order.tanggalPemesanan);
  final tanggal =
      '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}';
  final jam =
      '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

  final total = _calculateTotal(order);

  // Load logo dari assets
  final logoImage = await imageFromAssetBundle('assets/images/logo.png');

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(24),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(child: pw.Image(logoImage, height: 80)),
            pw.SizedBox(height: 12),

            pw.Center(
              child: pw.Text(
                'BUKTI TRANSAKSI',
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 16),

            pw.Text('Tanggal : $tanggal'),
            pw.Text('Jam     : $jam'),
            pw.Text('Status  : ${order.status}'),
            pw.Text('Alamat  : ${userAddress ?? 'Alamat tidak tersedia'}'),
            pw.SizedBox(height: 16),

            pw.Text('Rincian Layanan:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),

            // Tabel layanan dan harga
            pw.Table(
              columnWidths: {
                0: const pw.FlexColumnWidth(3),
                1: const pw.FlexColumnWidth(2),
              },
              border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey300),
              children: [
                // Header
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text('Layanan', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text('Harga',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.right),
                    ),
                  ],
                ),
                // Data
                ...order.orderDetails.map((detail) {
                  return pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text(detail.service.name),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text('Rp. ${detail.subtotal}',
                            textAlign: pw.TextAlign.right),
                      ),
                    ],
                  );
                }),
              ],
            ),

            pw.SizedBox(height: 16),
            pw.Divider(),

            // Total
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Total', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.Text('Rp. $total', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              ],
            ),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}
}
