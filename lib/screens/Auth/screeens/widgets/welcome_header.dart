import 'package:flutter/material.dart';

class WelcomeHeader extends StatefulWidget {
  const WelcomeHeader({super.key});

@override
  WelcomeHeaderState createState() => WelcomeHeaderState();
}

class WelcomeHeaderState extends State<WelcomeHeader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 2 * 3.14).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Khối xoay
          Positioned(
            top: -550, // Điều chỉnh vị trí nếu cần
            left: -200, // Điều chỉnh vị trí nếu cần
            child: AnimatedBuilder(
              animation: _animation,
              child: Container(
                width: 700,
                height: 700,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 40, 65, 119),
                  borderRadius: BorderRadius.circular(300.0),
                ),
              ),
              builder: (context, child) {
                return Transform.rotate(
                  angle: _animation.value,
                  child: child,
                );
              },
            ),
          ),
          // Văn bản "Welcome to Donna Stroupe."
          Positioned(
            top: 40,
            left: 10,
            child: MouseRegion(
              onEnter: (_) {},
              onExit: (_) {},
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: const Text(
                  'Welcome to Donna Stroupe.',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}