import 'package:HDTech/models/tshirt_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl for currency formatting

class ItemsDetails extends StatelessWidget {
  final Tshirt popularTshirtBar;

  const ItemsDetails({
    super.key,
    required this.popularTshirtBar,
  });

  @override
  Widget build(BuildContext context) {
    // Format the price using the Vietnamese currency format
    final formatCurrency =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');

    return Padding(
      padding: const EdgeInsets.all(10.0), // Overall padding for content
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display productsTypeName before name
          Text(
            popularTshirtBar.name,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 25,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),

          // Product price
          Text(
            formatCurrency
                .format(popularTshirtBar.price), // Format price with currency
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 22,
              color: Color.fromARGB(255, 18, 37, 102),
            ),
          ),
          const SizedBox(height: 10),

          // "Description:" title
          const Text(
            "Description:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 1.2,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10), // Space between title and content

          // List of product attributes

          _buildDetailRow("Quantity in Stock: ",
              popularTshirtBar.quantityInStock.toString()),
          _buildDetailRow(
              "Size: ", popularTshirtBar.size),
          _buildDetailRow(
              "Color: ", popularTshirtBar.color),
          _buildDetailRow("Brand: ", popularTshirtBar.brand),
          _buildDetailRow("Gender: ", popularTshirtBar.gender),
        ],
      ),
    );
  }

  // Method to build detail rows
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0), // Space between rows
      child: Row(
        children: [
          // Label
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              maxLines: 1,
            ),
          ),
          // Value
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
