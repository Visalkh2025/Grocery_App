import 'dart:developer';

import 'package:grocery_app/models/brand.dart';
import 'package:grocery_app/utils/api_client.dart';

class BrandService {
  final ApiClient _api = ApiClient();
  Future<List<Brand>> fetchBrands() async {
    try {
      final res = await _api.request(endpoint: "brand", method: "GET");
      if (res.statusCode == 200) {
        List data = res.data['brands'];
        return data.map((item) => Brand.fromJson(item)).toList();
      } else {
        log("Error to fetch brand: ${res.data['message']}");
        return [];
      }
    } catch (e) {
      log("Error fetching category $e");
      return [];
    }
  }
}
