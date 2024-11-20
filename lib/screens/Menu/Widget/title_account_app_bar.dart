import 'package:flutter/material.dart';

class TitleAccountAppBar extends StatelessWidget {
  const TitleAccountAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 195,
          height: 38,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Account & Settings',
                  style: TextStyle(
                    color: Color(0xFF1A242F),
                    fontSize: 22,
                    fontFamily: 'Airbnb Cereal App',
                    fontWeight: FontWeight.w500,
                    height: 1.0, // Fixed height property to ensure correct spacing.
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
