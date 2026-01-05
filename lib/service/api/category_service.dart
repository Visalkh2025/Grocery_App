import 'dart:developer';

import 'package:grocery_app/models/category.dart';
import 'package:grocery_app/utils/api_client.dart';

class CategoryService {
  final ApiClient _api = ApiClient();
  Future<List<Category>> fetchCategories() async {
    try {
      final res = await _api.request(endpoint: "category", method: "GET");
      if (res.statusCode == 200) {
        List<dynamic> data = res.data['category'];
        return data.map((item) => Category.fromJson(item)).toList();
      } else {
        log("Failed to fetch category: ${res.data['message']}");
        return [];
      }
    } catch (err) {
      log("Error fetching categories: $err");
      return [];
    }
  }
}
