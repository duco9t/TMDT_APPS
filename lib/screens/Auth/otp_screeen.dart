import 'dart:async';

import 'package:HDTech/models/api_service.dart'; // Import ApiService để gọi API
import 'package:HDTech/screens/Auth/logIn_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpScreen extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;

  const OtpScreen({
    super.key, // Keep the key here
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
  });

  @override
  OtpScreenState createState() => OtpScreenState();
}

class OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpToken = TextEditingController();
  final ApiService _apiService = ApiService(); // Use ApiService to call the API
  late Timer _timer;
  int _start = 60;
  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    _startTimer();
    otpToken.addListener(_onOtpChanged);
  }

  @override
  void dispose() {
    _timer.cancel();
    otpToken.removeListener(_onOtpChanged);
    otpToken.dispose();
    super.dispose();
  }

  void _onOtpChanged() {
    if (otpToken.text.length == 6) {
      _verifyOtp();
    }
  }

  Future<void> _verifyOtp() async {
    try {
      bool isVerified = await _apiService.verifyOtp(
        widget.email,
        otpToken.text,
      );

      // Kiểm tra xem widget có còn tồn tại không trước khi sử dụng context
      if (mounted) {
        if (isVerified) {
          // Hiển thị dialog đăng ký thành công
          _showDialog('Registration successful', () {
            // Chuyển sang trang LoginScreen sau khi nhấn OK
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          });
        } else {
          _showDialog('OTP authentication failed');
          otpToken.clear();
        }
      }
    } catch (e) {
      if (mounted) {
        _showDialog('An error occurred: $e');
      }
    }
  }

  void _showDialog(String message, [VoidCallback? onOkPressed]) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                // Nếu có callback onOkPressed, thực hiện nó
                if (onOkPressed != null) {
                  onOkPressed();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _startTimer() {
    setState(() {
      _isButtonDisabled = true;
      _start = 60;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isButtonDisabled = false;
        });
        _timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void _resendCode() async {
    // Gửi lại mã OTP với thông tin đã nhập
    bool success = await _apiService.signUp(
      widget.name,
      widget.email,
      widget.password,
      widget.confirmPassword,
      widget.phone,
    );

    if (success) {
      _startTimer(); // Reset timer
      _showDialog('OTP sent successfully');
    } else {
      _showDialog('Failed to resend OTP');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: otpToken,
              maxLength: 6,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Enter OTP',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                suffixIcon: TextButton(
                  onPressed: _isButtonDisabled ? null : _resendCode,
                  child: const Text('Resend Code'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Resend code in $_start seconds',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
