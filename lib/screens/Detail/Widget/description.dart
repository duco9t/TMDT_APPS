import 'package:flutter/material.dart';
import 'package:HDTech/constants.dart';

class Description extends StatelessWidget {
  final String description;
  const Description({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 120,
              height: 40,
              decoration: BoxDecoration(
                color: kprimaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: const Text(
                "Description",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 20), // Thêm khoảng cách giữa các Text widgets
            const Text(
              "Specifications",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 20), // Thêm khoảng cách giữa các Text widgets
            const Text(
              "Reviewers",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          description,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
