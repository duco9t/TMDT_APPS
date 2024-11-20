import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent, // Không có nền
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(3, (index) {
          return GestureDetector(
            onTap: () {
              onTap(index);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              width: selectedIndex == index ? 40.0 : 10.0, // Chiều rộng thay đổi
              height: 10.0, // Chiều cao cố định
              decoration: BoxDecoration(
                color: selectedIndex == index 
                    ? const Color.fromARGB(255, 40, 65, 119) 
                    : Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(5.0), // Đường viền chấm tròn
              ),
            ),
          );
        }),
      ),
    );
  }
}