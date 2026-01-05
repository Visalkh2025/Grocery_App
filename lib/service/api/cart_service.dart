import 'dart:developer';
import 'package:get/get.dart';
import 'package:grocery_app/models/cart.dart';
import 'package:grocery_app/utils/api_client.dart';

class CartService {
  final ApiClient _api = ApiClient();
  final Rx<Cart> cart = Cart.empty().obs;
  Future<void> createCard({required String productId}) async {
    try {
      final res = await _api.request(
        endpoint: "cart",
        method: "POST",
        data: {"productId": productId},
      );
      if (res.statusCode == 201) {
        // Get.snackbar('Success', res.data['message']);
        log("Cart created successfully");
      } else {
        log("Error creating cart: ${res.data['message']}");
        // Get.snackbar("Failed", res.data['message']);
      }
    } catch (e) {
      log("Error creating cart: $e");
    }
  }

  Future<Cart> fetchCard() async {
    try {
      final res = await _api.request(endpoint: "cart", method: "GET");

      if (res.statusCode == 200) {
        final data = res.data['items'];
        return Cart.fromJson({"_id": res.data['_id'], "userId": res.data['userId'], "items": data});
      } else {
        log("Error get cart ${res.data['message']}");
        return Cart.empty();
      }
    } catch (e) {
      log("Error fetching cart: $e");
      return Cart.empty();
    }
  }

  Future<void> updateQuantity({required String productId, required int quantity}) async {
    try {
      final res = await _api.request(
        endpoint: "cart/items/$productId",
        method: "PATCH",
        data: {"quantity": quantity},
      );
      if (res.statusCode == 200) {
        log("Cart updated successfully");
        // Get.snackbar('Success', res.data['message']);
        log(res.data.toString());
      } else {
        // Get.snackbar("Error", res.data['message']);
        log(res.data['message']);
      }
    } catch (err) {
      log("Error updated card $err");
    }
  }

  Future<void> removeItem({required String productId}) async {
    try {
      final res = await _api.request(endpoint: "cart/items/$productId", method: "DELETE");

      if (res.statusCode == 200) {
        // Get.snackbar('Success', res.data['message']);
        log("Item deleted successfully");
      } else {
        log("Error deleting item: ${res.data['message']}");
        // Get.snackbar("Failed", res.data['message']);
      }
    } catch (e) {
      log("Error deleting item: $e");
    }
  }

  Future<Map<String, dynamic>?> applyPromoCode(String code) async {
    try {
      final res = await _api.request(
        endpoint: "apply_promocode",
        method: "POST",
        data: {"code": code},
      );
      if (res.statusCode == 200) {
        Get.snackbar("Success", res.data['message']);
        return res.data;
      } else {
        Get.snackbar("Error", res.data['message']);
        return null;
      }
    } catch (err) {
      log("Errorr apply promocode: $err");
    }
    return null;
  }
  // handlecancle promocode
Future<void> handlecanclePromocode() async {
  try {
    final res = await _api.request(
      endpoint: "cancel_promocode",
      method: "DELETE",
    );
    if (res.statusCode == 200) {
      Get.snackbar("Success", res.data['message']);
      log("Promo code cancelled successfully");
    } else {
      Get.snackbar("Error", res.data['message']);
      log("Error cancelling promo code: ${res.data['message']}");
    }
  } catch (err) {
    log("Error cancelling promocode: $err");
  }
}

  Future<Map<String, dynamic>?> checkout({
    required double totalAmount,
    String? promoCode,
    // String? addressId,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final res = await _api.request(
        endpoint: "orders",
        method: "POST",
        data: {"items": items, "totalAmount": totalAmount, "promoCode": promoCode},
      );

      if (res.statusCode == 201) {
        log("Order created: ${res.data['orderId']}");
        return res.data;
      } else {
        log("Failed: ${res.data['message']}");
        return null;
      }
    } catch (e) {
      log("Error during checkout: $e");
      return null;
    }
  }
}
