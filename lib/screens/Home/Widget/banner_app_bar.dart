import 'dart:async';

import 'package:flutter/material.dart';

class BannerAppBar extends StatefulWidget {
  final List<String> bannerUrls; // Accept a list of banner URLs

  const BannerAppBar({
    super.key,
    required this.bannerUrls, // Make bannerUrls required
  });

  @override
  BannerAppBarState createState() => BannerAppBarState();
}

class BannerAppBarState extends State<BannerAppBar> {
  late PageController _pageController;
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel(); // Cancel the timer when disposing
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < widget.bannerUrls.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if there are any valid banners to display
    if (widget.bannerUrls.isEmpty) {
      return const SizedBox(); // Return empty if no banners
    }
    return SizedBox(
      height: 180, // Set the height for the banner
      child: PageView(
        controller: _pageController,
        children:
            widget.bannerUrls.map((url) => _buildBannerImage(url)).toList(),
      ),
    );
  }

  Widget _buildBannerImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20), // Round the corners
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover, // Scale the image to cover the banner
        width: double.infinity, // Make the image full width
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
      ),
    );
  }
}
