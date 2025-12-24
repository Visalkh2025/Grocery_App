import 'dart:developer';

import 'package:grocery_app/models/product.dart';
import 'package:grocery_app/utils/api_client.dart';

class ProductService {
  final ApiClient _api = ApiClient();
  List<Product> _products = [];
  Future<void> fetchProducts() async {
    try {
      final response = await _api.request(endpoint: "product", method: "GET");
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['products'];
        _products = data.map((item) => Product.fromJson(item)).toList();
      } else {
        log("Failed to fetch products: ${response.data['message']}");
      }
    } catch (err) {
      log("Error fetching products: " + err.toString());
    }
  }

  List<Product> get products => _products;
}
