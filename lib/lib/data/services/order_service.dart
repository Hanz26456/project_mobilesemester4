import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';
import '../models/order_request.dart';

class OrderService {
  static Future<bool> createOrder(OrderRequest order) async {
    final url = Uri.parse(
      '${Config.baseUrl}/orders',
    ); // Ganti sesuai base URL
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(order.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      print("Gagal order: ${response.body}");
      return false;
    }
  }
}
