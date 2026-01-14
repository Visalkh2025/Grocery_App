import 'package:get/get.dart';
import 'package:grocery_app/models/product.dart';

class OrderModel {
  final String orderId;
  final List<OrderItem> items;
  final int itemCount;
  final double totalAmount;
  final String orderStatus;
  final DateTime createdAt;

  OrderModel({
    required this.orderId,
    required this.items,
    required this.itemCount,
    required this.totalAmount,
    required this.orderStatus,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'],
      items: (json['items'] as List).map((e) => OrderItem.fromJson(e)).toList(),
      itemCount: json['itemCount'],
      totalAmount: (json['totalAmount'] as num).toDouble(),
      orderStatus: json['orderStatus'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

// class OrderItem {
//   final Product product;
//   final int quantity;
//   final double price;
//   final bool isReviewed; // NEW FIELD

//   OrderItem({
//     required this.product,
//     required this.quantity,
//     required this.price,
//     this.isReviewed = false,
//   });

//   factory OrderItem.fromJson(Map<String, dynamic> json) {
//     return OrderItem(
//       product: Product.fromJson(json['productId']),
//       quantity: json['quantity'],
//       price: (json['price'] as num).toDouble(),
//       isReviewed: json['isReviewed'] ?? false,
//     );
//   }
// }

class OrderItem {
  final Product product;
  final int quantity;
  final double price;
  final RxBool isReviewed;

  OrderItem({
    required this.product,
    required this.quantity,
    required this.price,
    bool isReviewed = false, // normal bool input
  }) : isReviewed = isReviewed.obs; // convert to RxBool

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      product: Product.fromJson(json['productId']),
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      // convert API response (object with _id or null) to bool
      isReviewed: (json['isReviewed']),
    );
  }
}
