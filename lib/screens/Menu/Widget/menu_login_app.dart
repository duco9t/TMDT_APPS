import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class MenuLoginApp extends StatelessWidget {
  final VoidCallback onLogin; // Callback để xử lý đăng nhập
  final VoidCallback onSignUp; // Callback để xử lý đăng ký

  const MenuLoginApp({
    super.key,
    required this.onLogin,
    required this.onSignUp,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Log in to continue using the service',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            // Nút Đăng Nhập
            ZoomTapAnimation(
              child: SizedBox(
                width: 200,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 243, 243, 243),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  ),
                  onPressed: onLogin,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            "images/icons/login-3-svgrepo-com.svg",
                            height: 30,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Log In',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SvgPicture.asset(
                        "images/icons/alt-arrow-right-svgrepo-com.svg",
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            
            // Nút Đăng Ký
            ZoomTapAnimation(
              child: SizedBox(
                width: 200,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 243, 243, 243),
                  ),
                  onPressed: onSignUp, // Sử dụng callback onSignUp
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            "images/icons/login-3-svgrepo-com.svg",
                            height: 30,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SvgPicture.asset(
                        "images/icons/alt-arrow-right-svgrepo-com.svg",
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}