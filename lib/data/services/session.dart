import 'package:home_service/data/services/database.dart';

class Sessionn {
  static Future<Map<String, dynamic>> user() async {
    final userList = await DatabaseHelper().getUser();

    if (userList.isEmpty) {
      return {
        'user_id': "",
        'email': "",
        'address': "",
        'role': "",
        'photo': "",
        'token': "",
      }; // default kosong
    }

    final user = userList.first;
    return {
      'user_id': user.id,
      'email': user.email,
      'address': user.address,
      'role': user.role,
      'photo': user.photo ?? '',
      'token': user.token ?? '',
    };
  }
}
