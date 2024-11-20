import 'package:HDTech/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import thư viện
import 'package:geolocator/geolocator.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSetting extends StatefulWidget {
  const AppSetting({super.key});

  @override
  AppSettingState createState() => AppSettingState();
}

class AppSettingState extends State<AppSetting> {
  bool _enableFaceIDForLogin = false;
  bool _enablePushNotifications = false;
  bool _enableLocationServices = false;

  final LocalAuthentication _localAuth = LocalAuthentication();
  final Logger logger = Logger();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Load faceID and other settings
    setState(() {
      _enableFaceIDForLogin = prefs.getBool('faceID') ?? false;
      _enablePushNotifications = prefs.getBool('pushNotifications') ?? false;
      _enableLocationServices = prefs.getBool('locationServices') ?? false;
    });

    // Check if email and password exist in FlutterSecureStorage
    final email = await _secureStorage.read(key: 'email');
    final password = await _secureStorage.read(key: 'password');

    if (email != null && password != null) {
      setState(() {
        _enableFaceIDForLogin =
            true; // Enable FaceID switch if credentials exist
      });
    } else {
      setState(() {
        _enableFaceIDForLogin =
            false; // Disable FaceID switch if credentials do not exist
      });
    }
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('faceID', _enableFaceIDForLogin);
    await prefs.setBool('pushNotifications', _enablePushNotifications);
    await prefs.setBool('locationServices', _enableLocationServices);
  }

  Future<void> _saveCredentials(String email, String password) async {
    await _secureStorage.write(key: 'email', value: email);
    await _secureStorage.write(key: 'password', value: password);
  }

  Future<void> _deleteCredentials() async {
    await _secureStorage.delete(key: 'email');
    await _secureStorage.delete(key: 'password');
  }
  
  Future<bool> getEnableLocationServices() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('locationServices') ?? false;
}


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'App Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),

          // Switch Face ID
          _buildSwitchRow(
            title: 'Face ID or Fingerprint for Log In',
            value: _enableFaceIDForLogin,
            onChanged: (value) {
              setState(() {
                _enableFaceIDForLogin = value;
              });
              _saveSettings();
              if (value) {
                _authenticateWithFaceID();
              } else {
                _deleteCredentials(); // Xóa thông tin khi tắt công tắc
              }
            },
          ),

          const SizedBox(height: 12),

          // Switch Push Notifications
          _buildSwitchRow(
            title: 'Enable Push Notifications',
            value: _enablePushNotifications,
            onChanged: (value) {
              setState(() {
                _enablePushNotifications = value;
              });
              _saveSettings();
              if (value) {
                FirebaseMessaging.instance.subscribeToTopic("user");
              } else {
                FirebaseMessaging.instance.unsubscribeFromTopic("user");
              }
            },
          ),

          const SizedBox(height: 12),

          // Switch Location Services
          _buildSwitchRow(
            title: 'Enable Location Services',
            value: _enableLocationServices,
            onChanged: (value) {
              setState(() {
                _enableLocationServices = value;
              });
              _saveSettings();
              if (value) {
                _checkLocationPermission();
              }
            },
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                color: Colors.black,
              ),
            ),
            Switch(
              value: value,
              activeTrackColor: kprimaryColor,
              onChanged: onChanged,
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }

  Future<void> _authenticateWithFaceID() async {
    bool authenticated = await _localAuth.authenticate(
      localizedReason: 'Authenticate to log in',
      options: const AuthenticationOptions(biometricOnly: true),
    );
    if (authenticated) {
      logger.i("Authentication successful");

      final prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString('email');
      String? password = prefs.getString('password');

      if (email != null && password != null) {
        await _saveCredentials(email, password);
        logger.i("Credentials saved: $email");
      } else {
        logger.e("No credentials found to save.");
      }
    } else {
      logger.e("Authentication failed");
    }
  }

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      logger.e("Location permissions are permanently denied");
    } else {
      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );

      Position position = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings);
      logger.i("Current position: $position");
    }
  }
}
