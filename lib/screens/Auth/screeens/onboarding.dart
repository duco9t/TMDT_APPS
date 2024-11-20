import 'package:HDTech/screens/Auth/logIn_screen.dart';
import 'package:flutter/material.dart';

import 'widgets/body_1.dart';
import 'widgets/body_2.dart';
import 'widgets/body_3.dart';
import 'widgets/custom_navigation_bar.dart';
import 'widgets/next_page.dart';
import 'widgets/welcome_header.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  OnboardingState createState() => OnboardingState();
}

class OnboardingState extends State<Onboarding> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _nextPage() {
    final currentPage = _currentPage; // Lưu _currentPage vào biến cục bộ
    if (currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const WelcomeHeader(),
          Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  children: const [
                    Body1(),
                    Body2(),
                    Body3(),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: CustomNavigationBar(
                      selectedIndex: _currentPage,
                      onTap: (index) {
                        _pageController.jumpToPage(index);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0, bottom: 20.0),
                    child: NextPage(
                      onTap: _nextPage,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
