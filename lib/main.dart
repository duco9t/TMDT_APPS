import 'package:HDTech/Provider/cart_provider.dart';
import 'package:HDTech/presentation/splash/pages/splash.dart';
import 'package:HDTech/screens/Auth/screeens/onboarding.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          textTheme: GoogleFonts.mulishTextTheme(),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
    _initializeFirebaseMessaging();
  }

  Future<void> _initializeFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Yêu cầu quyền thông báo
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    } else {}

    // Lắng nghe thông báo
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {});
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Onboarding()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SplashPage();
  }
}
