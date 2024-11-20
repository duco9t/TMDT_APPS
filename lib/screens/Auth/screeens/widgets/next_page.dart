// next_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NextPage extends StatelessWidget {
  final VoidCallback onTap;

  const NextPage({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60, // Kích thước nút
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white, // Màu nền
          shape: BoxShape.circle, // Hình dạng tròn
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3), // Độ lệch bóng
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            'images/icons/alt-arrow-right-svgrepo-com.svg', // Đường dẫn đến ảnh SVG của nút
            width: 30, // Kích thước biểu tượng
            height: 30,
          ),
        ),
      ),
    );
  }
}