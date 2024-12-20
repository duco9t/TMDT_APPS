import 'package:donna_stroupe/constants.dart';
import 'package:donna_stroupe/models/tshirt_model.dart';
import 'package:donna_stroupe/screens/Detail/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PopularTshirtBar extends StatefulWidget {
  final String searchQuery;

  const PopularTshirtBar({super.key, required this.searchQuery});

  @override
  PopularTshirtBarState createState() => PopularTshirtBarState();
}

class PopularTshirtBarState extends State<PopularTshirtBar> {
  late Future<List<Tshirt>> futureTshirts;

  @override
  void initState() {
    super.initState();
    futureTshirts = loadTshirts();
  }

  Future<void> _refreshTshirts() async {
    setState(() {
      futureTshirts = loadTshirts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Tshirt>>(
      future: futureTshirts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No tshirts found.'));
        }

        final tshirts = snapshot.data!;
        final filteredTshirts = tshirts.where((tshirt) {
          final query = widget.searchQuery.toLowerCase();
          return tshirt.name.toLowerCase().contains(query) ||
              tshirt.brand.toLowerCase().contains(query); // Tìm kiếm theo brand
        }).toList();

        return RefreshIndicator(
          onRefresh: _refreshTshirts,
          child: GridView.builder(
            padding: const EdgeInsets.only(
              left: 20.0, // Padding bên trái
              right: 20.0, // Padding bên phải
              bottom:
                  70.0, // Padding bên dưới để tránh bị che bởi BottomNavigationBar
            ),
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 0.65,
            ),
            itemCount: filteredTshirts.length,
            itemBuilder: (context, index) {
              final tshirt = filteredTshirts[index];
              return TshirtItem(tshirt: tshirt);
            },
          ),
        );
      },
    );
  }
}

class TshirtItem extends StatefulWidget {
  final Tshirt tshirt;

  const TshirtItem({super.key, required this.tshirt});

  @override
  State<TshirtItem> createState() => _TshirtItemState();
}

class _TshirtItemState extends State<TshirtItem> {
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return GestureDetector(
      onTapDown: (_) => setState(() => scale = 0.95),
      onTapUp: (_) {
        setState(() => scale = 1.0);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(popularTshirtBar: widget.tshirt),
          ),
        );
      },
      onTapCancel: () => setState(() => scale = 1.0),
      child: Transform.scale(
        scale: scale,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(widget.tshirt.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      widget
                          .tshirt.name, // Display productsTypeName before name
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Discounted Price
                        Text(
                          formatCurrency.format(widget.tshirt.promotionPrice),
                          style: const TextStyle(
                            fontSize: 18,
                            color: kprimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Original Price and Discount Percentage
                        if (widget.tshirt.price !=
                                widget.tshirt.promotionPrice &&
                            widget.tshirt.discount > 0)
                          Row(
                            children: [
                              // Original Price (crossed out)
                              Text(
                                formatCurrency.format(widget.tshirt.price),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Discount Percentage
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 208, 223,
                                      255), // Light red background
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '-${widget.tshirt.discount.toStringAsFixed(0)}%',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
