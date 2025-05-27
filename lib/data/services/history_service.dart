import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/models/order_response.dart'; // Sesuaikan path model
import 'config.dart';

Future<List<OrderResponse>> fetchUserOrders(int userId) async {
  
  final response = await http.get(
    Uri.parse('${Config.baseUrl}/orders/user/$userId'),

  );

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    print('Response data: $jsonData'); // Debugging line
    final List<dynamic> orders = jsonData['data'];
    return orders.map((e) => OrderResponse.fromJson(e)).toList();
  } else {
    throw Exception('Gagal memuat data riwayat pesanan');
  }
}
