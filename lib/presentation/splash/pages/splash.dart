import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 63, 63, 63),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "images/logo-app/logo.svg",
            ),
            LoadingAnimationWidget.threeRotatingDots(
              color: const Color.fromARGB(255, 255, 255, 255),
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
