import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/models/service_model.dart';
import 'config.dart'; // Sesuaikan path model

class ServiceService {
  

  static Future<List<ServiceModel>> getAllServices() async {
    final response = await http.get(Uri.parse('${Config.baseUrl}/services'));

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final List<dynamic> data = jsonBody['data'];
      return data.map((item) => ServiceModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }

  static Future<List<ServiceModel>> searchServices(String query) async {
    final response = await http.get(
      Uri.parse('${Config.baseUrl}/services?search=$query'),
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final List<dynamic> data = jsonBody['data'];
      return data.map((item) => ServiceModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to search services');
    }
  }
}
