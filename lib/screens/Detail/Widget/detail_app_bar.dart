import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailAppBar extends StatelessWidget {
  const DetailAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10), // Add padding to the container
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Adjust the alignment of items
        children: [
          // Left-side back button (SVG)
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              'images/icons/alt-arrow-left-svgrepo-com.svg', // Path to your SVG file
              height: 30, // Adjust size as needed
              width: 30, // Adjust size as needed
            ),
          ),
          // Centered text
          const Text(
            "Product Details",
            style: TextStyle(
              color: Color(0xFF1A242F),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          // Empty widget to maintain space between text and back button (to ensure proper layout)
          const SizedBox(width: 60), // Add some space on the right side
        ],
      ),
    );
  }
}
