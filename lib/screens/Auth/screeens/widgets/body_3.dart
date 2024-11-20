import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import thư viện SVG

class Body3 extends StatelessWidget {
  const Body3({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'images/icons/Get_your_order.svg',
            width: 300,
            height: 300,
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: const Column(
              children: [
                Text(
                  'Get your order',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Signifies the process of receiving or picking up your purchased items, completing the transaction.',
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