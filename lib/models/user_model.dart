import 'dart:convert';

import 'package:HDTech/models/config.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart'; // Import the logger package
import 'package:shared_preferences/shared_preferences.dart';

var logger = Logger();

class User {
  final String userId;
  final String name;
  final String email;
  final String phone;

  User({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['_id'], // Adjust if the actual response field is different
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}

class UserService {
  Future<Map<String, dynamic>?> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('id');
    logger.d('UserId from SharedPreferences: $userId');

    if (userId == null) {
      logger.e('UserId is null');
      return null;
    }

    final response = await http.get(
      Uri.parse('${Config.baseUrl}/user/get-details/$userId'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      logger.d('API Response: ${jsonResponse.toString()}');

      if (jsonResponse['status'] == 'Success' && jsonResponse['data'] != null) {
        logger.d('User data retrieved: ${jsonResponse['data']}');
        return jsonResponse['data'];
      } else {
        logger.e('Error in response data');
        return null;
      }
    } else {
      logger.e('Failed to load user data');
      return null;
    }
  }

  Future<bool> updateUserDetails(
    String userId,
    Map<String, dynamic> userData,
  ) async {
    if (userId.isEmpty) {
      logger.e('UserId is empty');
      return false;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUserId = prefs.getString('id');
    if (storedUserId == null) {
      logger.e('No userId found in SharedPreferences');
      return false;
    }

    final response = await http.put(
      Uri.parse('${Config.baseUrl}/user/update-user/$storedUserId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(userData),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      logger.d('API Response for update: ${jsonResponse.toString()}');

      if (jsonResponse['status'] == 'Success') {
        logger.i('User updated successfully');
        return true;
      } else {
        logger.e('Failed to update user: ${jsonResponse['message']}');
        return false;
      }
    } else {
      logger.e('Failed to make update request');
      return false;
    }
  }
}
