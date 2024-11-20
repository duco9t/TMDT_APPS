import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'config.dart'; // Import Config for base URL

class Tshirt {
  final String id;
  final String name;
  final String imageUrl;
  final String size;
  final String color;
  final String brand;
  final String gender;
  final String category;
  final double price;
  final String quantityInStock;
  int quantity;
  final String? bannerUrl; // Thêm bannerUrl, có thể null

  Tshirt({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantityInStock,
    required this.size,
    required this.color,
    required this.brand,
    required this.gender,
    required this.category,
    this.quantity = 1,
    this.bannerUrl,
  });

  // Add this toJson method to resolve the error
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'size': size,
      'color': color,
      'brand': brand,
      'gender': gender,
      'category': category,
      'price': price,
    };
  }

  factory Tshirt.fromJson(Map<String, dynamic> json) {
    return Tshirt(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown Tshirt',
      imageUrl:
          json['imageUrl'] as String? ?? 'https://via.placeholder.com/150',
      price: (json['prices'] as num?)?.toDouble() ?? 0.0,
      quantityInStock:
          json['quantityInStock'].toString(), // Ensure quantity as String
      quantity: json['quantity'] ?? 1, // Số lượng khi tạo từ JSON
      bannerUrl: json['bannerUrl'] as String?, // Nếu không có thì null
      size: json['size'] as String? ?? 'Unknown Size',
      color: json['color'] as String? ?? 'Unknown Color',
      brand: json['brand'] as String? ??
          'Unknown Brand' as String? ??
          'Unknown Tshirt',
      gender: json['gender'] as String? ?? 'Unknown Gender',
      category: json['category'] as String? ?? 'Unknown Category',
    );
  }
}

Future<List<Tshirt>> loadTshirts({Map<String, dynamic>? filters}) async {
  final response =
      await http.get(Uri.parse('${Config.baseUrl}/product/getAllProduct'));

  if (response.statusCode == 200) {
    try {
      final jsonResponse = json.decode(response.body);
      final data = jsonResponse['data'] as List;
      var tshirts = data.map((json) => Tshirt.fromJson(json)).toList();

      if (filters != null && filters.isNotEmpty) {
        tshirts = tshirts.where((tshirt) {
          bool matches = true;
          filters.forEach((field, value) {
            if (field == 'price') {
              // Handle price filter as a range
              if (value is RangeValues) {
                matches &=
                    (tshirt.price >= value.start && tshirt.price <= value.end);
              }
            } else if (value is List) {
              // For list filters (company, ram, etc.), check if the value is in the list
              matches &= value.contains(tshirt.toJson()[field]?.toString());
            } else {
              // For exact match filters (like productTypeName), check equality
              matches &=
                  tshirt.toJson()[field]?.toString() == value?.toString();
            }
          });
          return matches;
        }).toList();
      }

      return tshirts;
    } catch (e) {
      throw Exception('Failed to parse tshirts: $e');
    }
  } else {
    throw Exception(
        'Failed to load tshirts, status code: ${response.statusCode}');
  }
}
