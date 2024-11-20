import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

import 'config.dart';

final Logger logger = Logger();

class ApiService {
  final String baseUrl = Config.baseUrl;

  Future<Map<String, dynamic>?> signIn(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/sign-in'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      // Log the full response for debugging
      logger.d('Response Status: ${response.statusCode}');
      logger.d('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the response body
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        logger.d('Login response: $responseData');

        // Check for success status and user data
        if (responseData.containsKey('status') &&
            responseData['status'] == 'Oke' &&
            responseData.containsKey('dataUser') &&
            responseData['dataUser'] != null) {
          // Retrieve the userId from the response
          String userId =
              responseData['dataUser']['id'] ?? ''; // Corrected key reference
          if (userId.isEmpty) {
            logger.e('UserId is missing in the response.');
            return {
              'error':
                  'UserId missing in the response. Please check the server.'
            };
          }

          // Save the userId to SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('id', userId); // Store userId

          logger.d('UserId saved to SharedPreferences: $userId');
          return responseData; // Return response data
        } else {
          logger.e('Login failed or unexpected response structure');
          return {
            'error': 'Đăng nhập thất bại, vui lòng kiểm tra lại thông tin.'
          };
        }
      } else {
        logger.e('Failed login. Status code: ${response.statusCode}');
        return {
          'error': 'Đăng nhập thất bại, vui lòng kiểm tra lại thông tin.'
        };
      }
    } catch (e) {
      logger.e('Error occurred during sign-in: $e');
      return {'error': 'Đã xảy ra lỗi mạng, vui lòng thử lại.'};
    }
  }

  Future<bool> signUp(String name, String email, String password,
      String confirmPassword, String phone) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/sign-up'), // Cập nhật URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
          'phone': phone,
        }),
      );

      if (response.statusCode == 200) {
        return true; // Đăng ký thành công
      } else {
        return false; // Đăng ký thất bại
      }
    } catch (e) {
      return false; // Đăng ký thất bại do lỗi mạng
    }
  }

  Future<bool> verifyOtp(String email, String otpToken) async {
    logger.d('Email: $email');
    logger.d('OTP Token: $otpToken');

    try {
      final response = await http.post(
        Uri.parse('${Config.baseUrl}/otp/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'otpToken': otpToken,
        }),
      );

      logger.d('Response Status Code: ${response.statusCode}');
      logger.d('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        logger.d('Parsed Response: $jsonResponse');

        // Kiểm tra trường message
        if (jsonResponse['message'] == 'User registered successfully') {
          return true; // OTP verified successfully
        } else {
          return false; // OTP verification failed
        }
      } else {
        return false; // Nếu mã trạng thái không phải 201, trả về false
      }
    } catch (e) {
      logger.d('Exception occurred: $e');
      return false; // Nếu có lỗi trong quá trình gọi API
    }
  }
}
