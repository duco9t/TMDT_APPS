import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import thư viện SVG

class Body2 extends StatelessWidget {
  const Body2({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'images/icons/Track_Order.svg',
            width: 300,
            height: 300,
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: const Column(
              children: [
                Text(
                  'Track Order',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Allows customers to monitor the status and location of their orders in real-time, providing updates from processing to delivery.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}