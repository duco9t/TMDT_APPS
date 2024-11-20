import 'package:HDTech/constants.dart'; // Import constants.dart
import 'package:HDTech/models/tshirt_model.dart';
import 'package:flutter/material.dart';

class FilterDrawer extends StatefulWidget {
  final Function(Map<String, dynamic>) onFilterChanged;
  final List<Tshirt> tshirts;

  const FilterDrawer(
      {super.key, required this.onFilterChanged, required this.tshirts});

  @override
  FilterDrawerState createState() => FilterDrawerState();
}

class FilterDrawerState extends State<FilterDrawer> {
  final Map<String, dynamic> _selectedFilters = {};
  late List<String> _sizes;
  late List<String> _colors;
  late List<String> _brands;
  late List<String> _gender;

  @override
  void initState() {
    super.initState();

    // Extract unique values from the list of tshirts for each filter
    _sizes =
        _getUniqueValues(widget.tshirts, (tshirt) => tshirt.size);
    _colors = _getUniqueValues(widget.tshirts, (tshirt) => tshirt.color);
    _brands = _getUniqueValues(widget.tshirts, (tshirt) => tshirt.brand);
    _gender = _getUniqueValues(widget.tshirts, (tshirt) => tshirt.gender);
  }

  List<String> _getUniqueValues(
      List<Tshirt> tshirts, String Function(Tshirt) extractValue) {
    return tshirts.map(extractValue).toSet().toList(); // Get unique values
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white, // Set drawer background color to white
      child: SingleChildScrollView(
        // Enable scrolling
        child: Padding(
          padding: const EdgeInsets.only(top: 36.0), // Push content down
          child: Column(
            children: [
              // Filter buttons for each attribute
              _buildFilterButton('Size', _sizes, 'size'),
              _buildFilterButton('Color', _colors, 'color'),
              _buildFilterButton('Brand', _brands, 'brand'),
              _buildFilterButton('Gender', _gender, 'gender'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(
      String title, List<String> options, String filterKey) {
    return ExpansionTile(
      title: Text(title),
      children: options.map((option) {
        return RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: _selectedFilters[filterKey],
          onChanged: (String? value) {
            setState(() {
              _selectedFilters[filterKey] = value;
              _sendUpdatedFilters();
            });
          },
          activeColor: kPrimaryColor, // Set radio button color to primary color
        );
      }).toList(),
    );
  }

  void _sendUpdatedFilters() {
    // Clean filters to remove null or empty values
    final cleanedFilters = Map<String, dynamic>.from(_selectedFilters);
    cleanedFilters.removeWhere(
        (key, value) => value == null || (value is List && value.isEmpty));

    // Send updated filters
    widget.onFilterChanged(cleanedFilters);
  }
}
