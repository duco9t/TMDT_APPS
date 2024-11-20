import 'package:HDTech/models/tshirt_model.dart'; // Import model Tshirt để có dữ liệu
import 'package:HDTech/screens/Search/popular_computer_bar.dart'; // Giữ lại import này
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Tshirt>> futureTshirts;

  @override
  void initState() {
    super.initState();
    futureTshirts = loadTshirts(); // Gọi hàm để lấy danh sách máy tính
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 241, 241),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 241, 241, 241),
        elevation: 0,
        title: const Text(
          "",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0), // Set horizontal padding for TextField
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  // Cập nhật trạng thái khi có sự thay đổi trong ô tìm kiếm
                });
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            // Use Expanded here to ensure the list takes up available space
            child: FutureBuilder<List<Tshirt>>(
              future: futureTshirts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No computers found.'));
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      futureTshirts = loadTshirts();
                    });
                  },
                  child: PopularTshirtBar(
                    searchQuery:
                        _searchController.text, // Pass search query here
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
