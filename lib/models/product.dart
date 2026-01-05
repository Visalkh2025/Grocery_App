import 'package:grocery_app/models/brand.dart';

import 'category.dart';

class Product {
  final String id;
  final String name;
  final String? description;
  final List<String> image;
  final double price;
  final double finalPrice;
  final int stock;
  final int sold;
  final int discount;
  final String unit;
  final double rating;
  // final String? sku;
  final Category? category;
  final Brand? brand;
  final List<String> tags;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.image,
    required this.price,
    required this.finalPrice,
    required this.stock,
    required this.sold,
    required this.discount,
    required this.unit,
    required this.rating,
    // this.sku,
    this.category,
    this.brand,
    required this.tags,
    this.createdAt,
    this.updatedAt,
  });

  // factory Product.fromJson(Map<String, dynamic> json) {
  //   return Product(
  //     id: json['_id'] ?? json['id'],
  //     name: json['name'],
  //     description: json['description'],
  //     image: (json['image'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
  //     price: (json['price'] ?? 0).toDouble(),
  //     finalPrice: (json['finalPrice'] ?? json['price'] ?? 0).toDouble(),
  //     stock: (json['stock'] ?? 0).toInt(),
  //     sold: (json['sold'] ?? 0).toInt(),
  //     discount: (json['discount'] ?? 0).toInt(),
  //     unit: json['unit'] ?? "",
  //     rating: (json['rating'] ?? 0).toDouble(),
  //     // sku: json['sku'],
  //     category: json['category'] != null
  //         ? Category.fromJson(json['category'])
  //         : Category(id: '', name: 'Unknown', image: '', description: '', status: false),
  //     brand: json['brand'] != null
  //         ? Brand.fromJson(json['brand'])
  //         : Brand(id: '', name: 'Unknown', image: '', orginCountry: '', description: ''),
  //     tags: (json['tags'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
  //     createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
  //     updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
  //   );
  // }
  factory Product.empty() {
    return Product(
      id: '',
      name: 'Unknown Product',
      description: null,
      image: [],
      price: 0.0,
      finalPrice: 0.0,
      stock: 0,
      sold: 0,
      discount: 0,
      unit: '',
      rating: 0.0,
      category: Category(id: '', name: 'Unknown', image: '', description: '', status: false),
      brand: Brand(id: '', name: 'Unknown', image: '', originCountry: '', description: ''),
      tags: [],
      createdAt: null,
      updatedAt: null,
    );
  }
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? json['id'] ?? '', // default empty string
      name: json['name'] ?? 'Unknown Product', // default
      description: json['description'], // nullable
      image: (json['image'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(), // empty list if null
      price: (json['price'] ?? 0).toDouble(),
      finalPrice: (json['finalPrice'] ?? json['price'] ?? 0).toDouble(),
      stock: (json['stock'] ?? 0).toInt(),
      sold: (json['sold'] ?? 0).toInt(),
      discount: (json['discount'] ?? 0).toInt(),
      unit: json['unit'] ?? "",
      rating: (json['rating'] ?? 0).toDouble(),
      // category: json['category'] != null
      //     ? Category.fromJson(json['category'])
      //     : Category(id: '', name: 'Unknown', image: '', description: '', status: false),
      // brand: json['brand'] != null
      //     ? Brand.fromJson(json['brand'])
      //     : Brand(id: '', name: 'Unknown', image: '', originCountry: '', description: ''),
      category: json['category'] is Map
          ? Category.fromJson(json['category'])
          : (json['category'] is String
                ? Category(
                    id: json['category'],
                    name: 'Unknown',
                    image: '',
                    description: '',
                    status: false,
                  )
                : null),

      brand: json['brand'] is Map
          ? Brand.fromJson(json['brand'])
          : (json['brand'] is String
                ? Brand(
                    id: json['brand'],
                    name: 'Unknown',
                    image: '',
                    originCountry: '',
                    description: '',
                  )
                : null),

      tags: (json['tags'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }
}
