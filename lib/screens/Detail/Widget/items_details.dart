import 'package:donna_stroupe/constants.dart';
import 'package:donna_stroupe/models/tshirt_model.dart';
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
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

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

          // Product price and discount
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Discounted price
              Text(
                formatCurrency.format(popularTshirtBar.promotionPrice),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: kprimaryColor,
                ),
              ),
              // Original price and discount percentage
              if (popularTshirtBar.price != popularTshirtBar.promotionPrice &&
                  popularTshirtBar.discount > 0)
                Row(
                  children: [
                    // Original price (crossed out)
                    Text(
                      formatCurrency.format(popularTshirtBar.price),
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Discount percentage
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2), // Padding for better spacing
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                            255, 208, 225, 255), // Light red background
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '-${popularTshirtBar.discount.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 14,
                          color: kprimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
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
          _buildDetailRow("Size: ", popularTshirtBar.size),
          _buildDetailRow("Color: ", popularTshirtBar.color),
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
