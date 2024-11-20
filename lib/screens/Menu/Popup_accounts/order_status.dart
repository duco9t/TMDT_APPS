import 'package:HDTech/constants.dart';
import 'package:HDTech/models/order_model.dart';
import 'package:HDTech/screens/Menu/Popup_accounts/order_detail.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderStatusPage extends StatefulWidget {
  const OrderStatusPage({super.key});

  @override
  OrderStatusPageState createState() => OrderStatusPageState();
}

class OrderStatusPageState extends State<OrderStatusPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  List<Order> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Gọi API để lấy dữ liệu
    fetchOrdersData();
  }

  // Tạo instance của Logger
  var logger = Logger();

  Future<void> fetchOrdersData() async {
    try {
      // Kiểm tra xem userId có trong SharedPreferences hay không
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('id');
      logger.i("Fetched User ID from SharedPreferences: $userId");

      if (userId == null) {
        logger.e("User ID is null in SharedPreferences");
        throw Exception('User ID not found');
      }

      logger.i("User ID found: $userId");

      final fetchedOrders = await fetchOrders(); // Fetch orders based on userId
      setState(() {
        orders = fetchedOrders;
        isLoading = false;
      });

      logger.i("Fetched Orders: $orders");

      for (var order in orders) {
        logger.i("Order ID: ${order.id}, Status: ${order.status}");
      }
    } catch (e) {
      logger.e("Error fetching orders: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Shipped':
        return Colors.orange;
      case 'Delivered':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String formatPrice(double price) {
    final formatter = NumberFormat("#,###", "en_US");
    return "${formatter.format(price)} VNĐ";
  }

  String truncateString(String text, {int maxLength = 12}) {
    if (text.length > maxLength) {
      return '${text.substring(0, maxLength)}...';
    }
    return text;
  }

  String formatDate(String dateStr) {
    try {
      DateTime date =
          DateTime.parse(dateStr); // Chuyển đổi từ String thành DateTime
      return DateFormat('dd-MM-yyyy / HH:mm').format(date); // Định dạng lại
    } catch (e) {
      return dateStr; // Nếu không thể định dạng, trả về nguyên bản
    }
  }

  Widget buildOrderCard(Order order) {
    return Card(
      color: Colors.white,
      elevation: 4.0,
      shadowColor: Colors.black.withOpacity(0.2),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order ID: ${truncateString(order.id)}', // Cắt Order ID
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(formatDate(order.createdAt)), // Định dạng createdAt
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Tracking Number: ${truncateString(order.cartId)}'), // Cắt Tracking Number
                    Text('Quantity: ${order.products.length}'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Total: ${formatPrice(order.orderTotal)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.status,
                  style: TextStyle(
                      color: getStatusColor(order.status),
                      fontWeight: FontWeight.bold),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailPage(
                          orderStatus: order.status,
                          orderNumber: order.id,
                          trackingNumber: order.cartId,
                          deliveryAddress: order.shippingAddress,
                          products: order.products,
                          subtotal: order.totalPrice,
                          shipping: order.shippingFee,
                          totalPrice: order.orderTotal,
                          VATorder: order.vatOrder,
                          name: order.name,
                          phone: order.phone,
                        ),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: kPrimaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text('Details',
                      style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOrderList(String status) {
    final filteredOrders = orders
        .where((order) => order.status.toLowerCase() == status.toLowerCase())
        .toList();

    if (filteredOrders.isEmpty) {
      return const Center(child: Text("No orders found for this status"));
    }

    return ListView.builder(
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        return buildOrderCard(filteredOrders[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset('images/icons/alt-arrow-left-svgrepo-com.svg'),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Order Status'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ButtonsTabBar(
                    controller: _tabController,
                    backgroundColor: kPrimaryColor,
                    unselectedBackgroundColor: Colors.transparent,
                    unselectedLabelStyle: const TextStyle(color: Colors.black),
                    labelStyle: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    buttonMargin: const EdgeInsets.symmetric(horizontal: 18.0),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 16.0),
                    radius: 100,
                    tabs: const [
                      Tab(text: 'Pending'),
                      Tab(text: 'Shipped'),
                      Tab(text: 'Delivered'),
                      Tab(text: 'Cancelled'),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await fetchOrdersData(); // Wait for the data to be fetched
                    },
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        buildOrderList('Pending'),
                        buildOrderList('Shipped'),
                        buildOrderList('Delivered'),
                        buildOrderList('Cancelled'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
