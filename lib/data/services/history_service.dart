import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/models/order_response.dart'; // Sesuaikan path model

Future<List<OrderResponse>> fetchUserOrders(int userId) async {
  final response = await http.get(
    Uri.parse('http://192.168.0.105:8000/api/orders/user/$userId'),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return (data['data'] as List)
        .map((json) => OrderResponse.fromJson(json))
        .toList();
  } else {
    throw Exception('Failed to load orders');
  }
}
