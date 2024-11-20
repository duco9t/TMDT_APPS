import 'dart:convert';

import 'package:HDTech/models/config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AccountService {
  Future<Map<String, dynamic>?> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('id');
    String? accessToken = prefs.getString('access_token');

    if (userId == null || accessToken == null) {
      return null; // Trả về null nếu không có thông tin cần thiết
    }

    final response = await http.get(
      Uri.parse('${Config.baseUrl}/user/get-details/$userId'),
      headers: {
        'token': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'Oke' && jsonResponse['data'] != null) {
        return jsonResponse['data']; // Trả về thông tin người dùng
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
