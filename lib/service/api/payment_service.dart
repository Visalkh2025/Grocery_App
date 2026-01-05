import 'dart:developer';
import 'package:get/get.dart';
import 'package:grocery_app/utils/api_client.dart';

class PaymentService {
  final ApiClient _api = ApiClient();

  /// Create KHQR payment for an order
  Future<Map<String, dynamic>?> createPayment({
    required String orderId,

    String paymentMethod = "KHQR",
  }) async {
    try {
      final res = await _api.request(
        endpoint: "create_payment",
        method: "POST",
        data: {"orderId": orderId, "paymentMethod": paymentMethod},
      );

      if (res.statusCode == 201) {
        log("Payment created: ${res.data['payment']}");
        return res.data['payment'];
      } else {
        log("Failed to create payment: ${res.data['message']}");
        return null;
      }
    } catch (e) {
      log("Error creating payment: $e");
      return null;
    }
  }

  /// Check payment status by MD5 from KHQR
  Future<Map<String, dynamic>?> checkPayment({required String md5}) async {
    try {
      final res = await _api.request(endpoint: "check_payment", method: "POST", data: {"md5": md5});

      if (res.statusCode == 200) {
        log("Payment confirmed");
        return res.data;
      } else {
        log("Payment not completed: ${res.data['message']}");
        return null;
      }
    } catch (e) {
      log("Error checking payment: $e");
      return null;
    }
  }
}
