import 'package:donna_stroupe/models/cart_model.dart';

class CheckoutDetails {
  final String cartId;
  final List<CartItem> products;
  final double totalPrice;
  final double shippingFee;
  final double orderTotal;

  CheckoutDetails({
    required this.cartId,
    required this.products,
    required this.totalPrice,
    required this.shippingFee,
    required this.orderTotal,
  });

  factory CheckoutDetails.fromJson(Map<String, dynamic> json) {
    // Calculate base total price from JSON
    final basePrice = json['totalPrice'].toDouble();

    // Shipping fee calculation based on total price
    final calculatedShippingFee = calculateShippingFee(basePrice);

    // Calculate final order total
    final calculatedOrderTotal = basePrice + calculatedShippingFee;
    final cartId = json['_id'];

    return CheckoutDetails(
      cartId: cartId,
      products: (json['products'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      totalPrice: basePrice,
      shippingFee: calculatedShippingFee,
      orderTotal: calculatedOrderTotal,
    );
  }

  // Helper method to calculate shipping fee based on order value
  static double calculateShippingFee(double totalPrice) {
    if (totalPrice > 500000) {
      return 0.0;
    } else {
      return 50000.0;
    }
  }
}
