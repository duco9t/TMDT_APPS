import 'package:flutter/material.dart';

class MyImageSlider extends StatelessWidget {
  final Function(int) onChange;
  final List<String> images;

  const MyImageSlider({
    super.key,
    required this.images,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250, // Adjust this height as per your design requirement
      child: PageView.builder(
        onPageChanged: onChange,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16), // Add horizontal padding here
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  20), // Adjust the radius for rounded corners
              child: Image.network(
                images[index],
                fit: BoxFit.cover, // Make sure the image covers the area
                width: double
                    .infinity, // Ensure the image stretches across the container
                height:
                    double.infinity, // Ensure the image covers the full height
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Text("Image not available"),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
