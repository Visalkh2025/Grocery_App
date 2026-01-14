import 'dart:developer';

import 'package:grocery_app/models/product.dart';
import 'package:grocery_app/utils/api_client.dart';

class ProductService {
  final ApiClient _api = ApiClient();
  Future<List<Product>> fetchProducts({final String sort = ""}) async {
    int page = 1;
    int limit = 20;
    String search = "";
    try {
      final response = await _api.request(
        endpoint: "product",
        method: "GET",
        query: {
          "page": page,
          "limit": limit,
          if (search.isNotEmpty) "search": search,
          "sort": sort,
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['products'];
        return data.map((item) => Product.fromJson(item)).toList();

        // _products = data.map((item) => Product.fromJson(item)).toList();
      } else {
        log("Failed to fetch products: ${response.data['message']}");
        return [];
      }
    } catch (err) {
      log("Error fetching products: $err");
      return [];
    }
  }

  Future<List<Product>> fetchProductsByCategory(String categoryId) async {
    try {
      final response = await _api.request(endpoint: "product?category=$categoryId", method: "GET");
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['products'];
        return data.map((item) => Product.fromJson(item)).toList();
      } else {
        log("Failed to fetch products by category: ${response.data['message']}");
        return [];
      }
    } catch (err) {
      log("Error fetching products by category: $err");
      return [];
    }
  }

  Future<Product> fetchSingleProduct({required String productId}) async {
    try {
      final res = await _api.request(endpoint: "product/$productId", method: "GET");
      if (res.statusCode == 200) {
        final data = res.data['product'];
        return Product.fromJson(data);
      } else {
        log("Failed to fetch product: ${res.data['message']}");
        return Product.empty();
      }
    } catch (err) {
      log("Error fetching product: $err");
      return Product.empty();
    }
  }

  Future<List<Product>> searchProduct(String query) async {
    try {
      final res = await _api.request(endpoint: "product?search=$query", method: "GET");
      if (res.statusCode == 200) {
        List data = res.data['products'];
        return data.map((item) => Product.fromJson(item)).toList();
      } else {
        log("Failed to search product: ${res.data['message']}");
        return [];
      }
    } catch (err) {
      log("Error Search product: $err");
      return [];
    }
  }
}
