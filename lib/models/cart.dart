import 'package:grocery_app/models/product.dart';

class Cart {
  final String? id;
  final String? userId;
  final List<Item> items;

  Cart({required this.id, required this.userId, required this.items});

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json["_id"],
      userId: json["userId"],
      items: json["items"] != null
          ? List<Item>.from((json["items"] as List).map((x) => Item.fromJson(x)))
          : [],
    );
  }

  factory Cart.empty() {
    return Cart(id: '', userId: "", items: []);
  }
}

class Item {
  final String? id;
  int quantity;
  final DateTime? addedAt;
  final Product? product;

  Item({required this.id, required this.quantity, required this.addedAt, required this.product});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json["_id"],
      quantity: (json["quantity"] ?? 0).toInt(),
      addedAt: (json["addedAt"] != null && json["addedAt"] != "")
          ? DateTime.tryParse(json["addedAt"])
          : null,
      product: json["product"] != null
          ? Product.fromJson(json["product"] as Map<String, dynamic>)
          : null,
    );
  }
}

// class Product {
//   Product({
//     required this.id,
//     required this.name,
//     required this.price,
//     required this.unit,
//     required this.images,
//   });

//   final String? id;
//   final String? name;
//   final double? price;
//   final String? unit;
//   final List<String> images;

//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json["_id"],
//       name: json["name"],
//       price: json["price"],
//       unit: json["unit"],
//       images: json["image"] == null ? [] : List<String>.from(json["image"].map((x) => x)),
//     );
//   }
// }
