import 'package:donna_stroupe/Provider/cart_provider.dart';
import 'package:donna_stroupe/constants.dart';
import 'package:donna_stroupe/models/review_model.dart';
import 'package:donna_stroupe/models/tshirt_model.dart';
import 'package:donna_stroupe/screens/Auth/login_screen.dart';
import 'package:donna_stroupe/screens/Detail/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PopularTshirtBar extends StatefulWidget {
  final bool isRefreshing;
  final List<Tshirt> tshirts; // Add this line
  final Map<String, dynamic> filters; // Added this line for filters

  const PopularTshirtBar(
      {super.key,
      this.isRefreshing = false,
      required this.tshirts,
      required this.filters}); // Modified constructor

  @override
  PopularTshirtBarState createState() => PopularTshirtBarState();
}

class PopularTshirtBarState extends State<PopularTshirtBar> {
  late Future<List<Tshirt>> futureTshirts;
  late List<double> scales;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    futureTshirts = loadTshirts();
    scales = [];
    _checkLoginStatus(); // Kiểm tra trạng thái đăng nhập khi khởi tạo
  }

  void reloadTshirts() {
    setState(() {
      futureTshirts = loadTshirts(); // Triggers rebuild with the filtered data
    });
  }

  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  // Modify the loadTshirts function to show all products initially
  Future<List<Tshirt>> loadTshirts() async {
    List<Tshirt> filteredTshirts = widget.tshirts;

    if (widget.filters.isNotEmpty) {
      // Kiểm tra bộ lọc theo price
      if (widget.filters.containsKey('price')) {
        final RangeValues priceRange = widget.filters['price'];
        filteredTshirts = filteredTshirts
            .where((tshirt) =>
                tshirt.price >= priceRange.start &&
                tshirt.price <= priceRange.end)
            .toList();
      }

      // Áp dụng các bộ lọc khác nếu có
      widget.filters.forEach((key, value) {
        if (key != 'price' && key != 'categoryId') {
          filteredTshirts = filteredTshirts
              .where((tshirt) => (tshirt.toJson()[key] as List).contains(value))
              .toList();
        }
      });
    }

    return filteredTshirts;
  }

  Future<void> _navigateToLogin() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );

    // Nếu người dùng đăng nhập thành công, cập nhật trạng thái
    if (result == true) {
      setState(() {
        _isLoggedIn = true;
      });
    }
  }

// Hàm hiển thị hộp thoại yêu cầu đăng nhập
  Future<bool> _showLoginDialog() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible:
              false, // Ngăn không cho đóng hộp thoại khi bấm ra ngoài
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              backgroundColor: Colors.white,
              contentPadding: const EdgeInsets.all(
                  20), // Thêm padding cho nội dung hộp thoại
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tiêu đề
                  const Center(
                    child: Text(
                      "Login Required",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Nội dung hộp thoại
                  Text(
                    "You need to be logged in to add items to the cart. Would you like to log in now?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Các nút lựa chọn
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Nút "No"
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pop(false); // Nếu người dùng chọn "No"
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          "No",
                          style: TextStyle(
                            color: Colors.blue[300],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),

                      // Nút "Yes"
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pop(true); // Nếu người dùng chọn "Yes"
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Yes",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ) ??
        false; // Trả về false nếu người dùng không chọn gì
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartProvider>(context,
        listen: false); // Khai báo provider để sử dụng addToCart

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

        if (scales.length != tshirts.length) {
          scales = List<double>.filled(tshirts.length, 1.0);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Transform.translate(
            offset: const Offset(0, -25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio:
                        0.68, // Giảm giá trị childAspectRatio để sản phẩm dài hơn
                  ),
                  itemCount: tshirts.length,
                  itemBuilder: (context, index) {
                    final tshirt = tshirts[index];
                    return GestureDetector(
                      onTapDown: (_) {
                        setState(() {
                          scales[index] = 0.95;
                        });
                      },
                      onTapUp: (_) {
                        setState(() {
                          scales[index] = 1.0;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(
                              popularTshirtBar: tshirt,
                            ),
                          ),
                        );
                      },
                      onTapCancel: () {
                        setState(() {
                          scales[index] = 1.0;
                        });
                      },
                      child: Transform.scale(
                        scale: scales[index],
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
                                    height:
                                        100, // Tăng chiều cao của hình ảnh sản phẩm
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        image: NetworkImage(tshirt.imageUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      tshirt.name,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Chỉ hiển thị promotionPrice
                                        Text(
                                          NumberFormat.currency(
                                                  locale: 'vi_VN', symbol: 'đ')
                                              .format(tshirt.promotionPrice),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        // Giá giảm
                                        if (tshirt.price !=
                                                tshirt.promotionPrice ||
                                            tshirt.discount != 0)
                                          Row(
                                            children: [
                                              // Giá gốc (price) gạch ngang
                                              if (tshirt.price !=
                                                  tshirt.promotionPrice)
                                                Text(
                                                  NumberFormat.currency(
                                                          locale: 'vi_VN',
                                                          symbol: 'đ')
                                                      .format(tshirt.price),
                                                  style: const TextStyle(
                                                    fontSize:
                                                        13, // Kích thước nhỏ hơn
                                                    color: Colors
                                                        .grey, // Màu xám cho giá gốc
                                                    decoration: TextDecoration
                                                        .lineThrough, // Gạch ngang giá gốc
                                                  ),
                                                ),
                                              const SizedBox(width: 8),
                                              if (tshirt.discount != 0)
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 6,
                                                      vertical:
                                                          2), // Thêm padding để chữ không bị sát viền
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 208, 223, 255),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6), // Bo góc nhẹ cho nền
                                                  ),
                                                  child: Text(
                                                    '-${tshirt.discount.toStringAsFixed(0)}%',
                                                    style: const TextStyle(
                                                      fontSize:
                                                          12, // Chữ nhỏ hơn
                                                      color:
                                                          kPrimaryColor, // Màu chữ trắng
                                                      fontWeight: FontWeight
                                                          .bold, // In đậm chữ
                                                    ),
                                                  ),
                                                )
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 6),
                                  // Hiển thị đánh giá
                                  FutureBuilder<Map<String, dynamic>>(
                                    future: fetchReviews(tshirt.id),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return const Text(
                                            'Không thể tải đánh giá.');
                                      } else if (snapshot.hasData) {
                                        final data = snapshot.data!;
                                        final averageRating =
                                            (data['averageRating'] as num)
                                                .toDouble();
                                        final reviews =
                                            data['reviews'] as List<Review>;

                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Row(
                                                    children: List.generate(
                                                      5,
                                                      (index) => Icon(
                                                        index <
                                                                averageRating
                                                                    .round()
                                                            ? Icons.star
                                                            : Icons.star_border,
                                                        color: Colors.amber,
                                                        size: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    '(${reviews.length})',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        // Khi đang tải, hiển thị nội dung trống hoặc thông báo đơn giản
                                        return const SizedBox(); // Hiển thị trống
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () async {
                                  // Kiểm tra nếu chưa đăng nhập, hiển thị hộp thoại yêu cầu đăng nhập
                                  if (!_isLoggedIn) {
                                    bool shouldLogin =
                                        await _showLoginDialog(); // Hiển thị hộp thoại
                                    if (!shouldLogin) {
                                      return; // Nếu người dùng không muốn đăng nhập, không làm gì
                                    }
                                    await _navigateToLogin(); // Nếu người dùng đồng ý đăng nhập, điều hướng đến màn hình đăng nhập
                                    if (!_isLoggedIn) {
                                      return; // Nếu sau khi đăng nhập, người dùng vẫn chưa đăng nhập, không tiếp tục
                                    }
                                  }

                                  // Lấy userId từ SharedPreferences
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  final userId = prefs
                                      .getString('id'); // Lấy userId đã lưu

                                  if (userId == null) {
                                    // Nếu không có userId, yêu cầu người dùng đăng nhập lại hoặc thông báo lỗi
                                    return;
                                  }

                                  // Gọi CartProvider để thêm sản phẩm vào giỏ hàng
                                  await provider.addItem(
                                      userId,
                                      tshirt.id.toString(),
                                      1); // Đảm bảo chuyển id thành String
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Sản phẩm đã được thêm vào giỏ hàng')),
                                  );
                                },
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: const BoxDecoration(
                                    color: kprimaryColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
