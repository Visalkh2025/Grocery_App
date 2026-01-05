import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:grocery_app/pages/order_accepted_page.dart';
import 'package:grocery_app/pages/khqr_payment_page.dart';
import 'package:grocery_app/service/api/payment_service.dart';

enum PaymentMethod { KHQR, ABA, AC }

class PaymentController extends GetxController {
  final PaymentService paymentService = PaymentService();

  Rx<PaymentMethod?> selectedMethod = Rx<PaymentMethod?>(null);
  var paymentData = Rxn<Map<String, dynamic>>();
  var isLoading = false.obs;
  RxInt countdown = 300.obs; // 5 minutes
  Timer? _countdownTimer;
  Timer? _pollingTimer;

  void selectPayment(PaymentMethod method) {
    selectedMethod.value = method;
  }

  Future<void> createPayment({required String orderId}) async {
    if (selectedMethod.value == null) {
      Get.snackbar("Error", "Please select a payment method");
      return;
    }

    isLoading(true);

    final payment = await paymentService.createPayment(
      orderId: orderId,
      paymentMethod: selectedMethod.value.toString().split('.').last,
    );

    if (payment != null) {
      paymentData.value = payment; // store in Rx
      log("Payment created: ${paymentData.value!['payment']['qr']}");

      // Start countdown timer
      startCountdown(300);

      // Start polling payment status
      startPolling();

      // Navigate to KHQR page immediately
      Get.to(
        () => KHQRPaymentPage(
          qr: paymentData.value!['payment']['qr'],
          expiration: paymentData.value!['payment']['expiration'],
          amountUsd: paymentData.value!['amountPaid'],
          amountKhr: paymentData.value!['payment']['amount'],
          deepLink: paymentData.value!['payment']['deepLink'],
        ),
      );
    } else {
      Get.snackbar("Error", "Failed to create payment");
    }

    isLoading(false);
  }

  void startCountdown(int seconds) {
    countdown.value = seconds;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (countdown.value <= 0) {
        _countdownTimer?.cancel();
        Get.snackbar("Expired", "Payment QR code has expired");
      } else {
        countdown.value--;
      }
    });
  }

  void startPolling({int interval = 5}) {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(Duration(seconds: interval), (_) async {
      if (paymentData.value == null) return;

      final md5 = paymentData.value!['payment']['md5'];
      final result = await paymentService.checkPayment(md5: md5);

      if (result != null && result['success'] == true) {
        log("Payment confirmed!");
        _pollingTimer?.cancel();
        _countdownTimer?.cancel();
        Get.offAll(() => OrderAcceptedPage());
      }
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _countdownTimer?.cancel();
  }

  @override
  void onClose() {
    stopPolling();
    super.onClose();
  }
}
