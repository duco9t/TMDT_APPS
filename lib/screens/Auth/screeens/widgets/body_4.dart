import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import thư viện SVG

class Body4 extends StatelessWidget {
  const Body4({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'images/icons/Purchase_online.svg',
            width: 300,
            height: 300,
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: const Column(
              children: [
                Text(
                  'Purchase Online',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Easily shop for your favorite products online with just a few clicks.',
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