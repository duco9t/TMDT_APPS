import 'package:HDTech/constants.dart';
import 'package:HDTech/screens/Cart/cart_screen.dart';
import 'package:HDTech/screens/Home/home_screen.dart';
import 'package:HDTech/screens/Menu/menu_user.dart';
import 'package:HDTech/screens/Search/search_screen.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;

  List screens = const [
    HomeScreen(),
    SearchScreen(),
    CartScreen(),
    Scaffold(),
    MenuUser(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,

      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: kprimaryColor.withOpacity(0.22),
              spreadRadius: 4,
              blurRadius: 6,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              currentIndex = 2;
            });

            // Hiển thị thông báo đè lên, không làm giỏ hàng nhảy lên
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Chuyển đến giỏ hàng!"),
                behavior:
                    SnackBarBehavior.floating, // Đè lên, không đẩy nội dung
                backgroundColor: Colors.black.withOpacity(0.8),
                margin: const EdgeInsets.only(
                  bottom: 80, // Đẩy Snackbar lên trên FloatingActionButton
                  left: 16,
                  right: 16,
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          shape: const CircleBorder(),
          backgroundColor: kprimaryColor,
          child: SvgPicture.asset(
            'images/icons/cart-2-svgrepo-com.svg',
            width: 35,
            height: 35,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Thanh điều hướng dưới cùng
      bottomNavigationBar: BottomAppBar(
        elevation: 1,
        height: 60,
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 12,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  currentIndex = 0;
                });
              },
              icon: SvgPicture.asset(
                'images/icons/home-smile-svgrepo-com.svg',
                width: 30,
                height: 30,
                colorFilter: ColorFilter.mode(
                  currentIndex == 0 ? kprimaryColor : Colors.grey.shade400,
                  BlendMode.srcIn,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  currentIndex = 1;
                });
              },
              icon: SvgPicture.asset(
                'images/icons/magnifer-svgrepo-com.svg',
                width: 30,
                height: 30,
                colorFilter: ColorFilter.mode(
                  currentIndex == 1 ? kprimaryColor : Colors.grey.shade400,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  currentIndex = 3;
                });
              },
              icon: SvgPicture.asset(
                'images/icons/bell-svgrepo-com.svg',
                width: 30,
                height: 30,
                colorFilter: ColorFilter.mode(
                  currentIndex == 3 ? kprimaryColor : Colors.grey.shade400,
                  BlendMode.srcIn,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  currentIndex = 4;
                });
              },
              icon: SvgPicture.asset(
                'images/icons/user-svgrepo-com.svg',
                width: 30,
                height: 30,
                colorFilter: ColorFilter.mode(
                  currentIndex == 4 ? kprimaryColor : Colors.grey.shade400,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),

      body: PageTransitionSwitcher(
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
            SharedAxisTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
        ),
        child: screens[currentIndex],
      ),
    );
  }
}
