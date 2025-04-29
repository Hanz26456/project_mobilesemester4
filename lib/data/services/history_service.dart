import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/models/order_response.dart'; // Sesuaikan path model

Future<List<OrderResponse>> fetchUserOrders(int userId) async {
  final response = await http.get(
    Uri.parse('http://192.168.1.30/KopiPos/public/api/orders/user/$userId'),
  );

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final List<dynamic> orders = jsonData['data'];
    return orders.map((e) => OrderResponse.fromJson(e)).toList();
  } else {
    throw Exception('Gagal memuat data riwayat pesanan');
  }
}
