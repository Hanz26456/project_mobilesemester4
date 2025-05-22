import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/order_pekerja_model.dart';
import '../services/config.dart';

class OrderPekerjaService {
  Future<List<OrderPekerja>> getMyOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) throw Exception("Token tidak ditemukan");

    final response = await http.get(
      Uri.parse('${Config.baseUrl}/my-orders'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body)['data'];
      return data.map((e) => OrderPekerja.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil order pekerja");
    }
  }
}
