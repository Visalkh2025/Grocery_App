import 'dart:developer';

import 'package:grocery_app/models/order_model.dart';
import 'package:grocery_app/utils/api_client.dart';

class OrderService {
  final ApiClient _api = ApiClient();

  Future<List<OrderModel>> fetchMyOrdersOld() async {
    try {
      final res = await _api.request(endpoint: "user/order_history", method: "GET");
      if (res.statusCode == 200) {
        final data = res.data;

        return (data['orders'] as List).map((item) => OrderModel.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (err) {
      log(err.toString());
      return [];
    }
  }

  Future<Map<String, dynamic>> fetchMyOrders() async {
    try {
      final res = await _api.request(endpoint: "user/order_history", method: "GET");

      if (res.statusCode == 200) {
        return {
          "count": res.data['count'],
          "orders": (res.data['orders'] as List).map((e) => OrderModel.fromJson(e)).toList(),
        };
      }
      return {"count": 0, "orders": []};
    } catch (err) {
      log(err.toString());
      return {"count": 0, "orders": []};
    }
  }
}
