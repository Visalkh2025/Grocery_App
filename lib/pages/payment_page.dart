import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_app/controller/payment_controller.dart';
import 'package:grocery_app/pages/khqr_payment_page.dart';
import 'package:grocery_app/widget/Payment_QR_Dialog.dart';

class PaymentPage extends StatelessWidget {
  final String orderId;
  PaymentPage({required this.orderId});

  final PaymentController controller = Get.put(PaymentController());

  // Define which methods are currently available
  final Set<PaymentMethod> availableMethods = {PaymentMethod.KHQR};

  @override
  Widget build(BuildContext context) {
    PaymentController controller = Get.put(PaymentController());

    final payment = controller.paymentData.value;
    return Scaffold(
      appBar: AppBar(title: const Text("Select Payment Method")),
      body: Obx(() {
        final bool canPay = availableMethods.contains(controller.selectedMethod.value);

        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildPaymentOption(
                    method: PaymentMethod.KHQR,
                    logo: "assets/images/payment/KHQR.png",
                    name: "KHQR (Bakong QR)",
                    isAvailable: true,
                  ),
                  const SizedBox(height: 12),
                  _buildPaymentOption(
                    method: PaymentMethod.ABA,
                    logo: "assets/images/payment/ABA.png",
                    name: "ABA Pay",
                    isAvailable: false,
                  ),
                  const SizedBox(height: 12),
                  _buildPaymentOption(
                    method: PaymentMethod.AC,
                    logo: "assets/images/payment/AC.png",
                    name: "Acleda",
                    isAvailable: false,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: canPay ? null : Colors.grey, // Visual feedback
                ),
                onPressed: (controller.isLoading.value || !canPay)
                    ? null
                    : () async {
                        await controller.createPayment(orderId: orderId);

                        // final payment = controller.paymentData.value;
                        // if (payment?['payment'] != null) {
                        //   Get.to(
                        //     () => KHQRPaymentPage(
                        //       qrData: payment!['payment']['qr'],
                        //       expirationTimestamp: payment['payment']['expiration'],
                        //     ),
                        //   );
                        // } else {
                        //   Get.snackbar("Error", "Payment QR not available");
                        // }
                      },

                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Pay Now",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildPaymentOption({
    required PaymentMethod method,
    required String logo,
    required String name,
    required bool isAvailable,
  }) {
    final bool isSelected = controller.selectedMethod.value == method;

    return Opacity(
      opacity: isAvailable ? 1.0 : 0.5, // Grey out unavailable options
      child: Card(
        elevation: isAvailable ? 4 : 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            if (isAvailable) {
              controller.selectPayment(method);
            } else {
              Get.snackbar(
                "Coming Soon",
                "This payment method will be available soon.",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.orange.shade600,
                colorText: Colors.white,
                margin: const EdgeInsets.all(16),
                duration: const Duration(seconds: 2),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              children: [
                // Logo on the left
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    logo,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported, size: 30);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // Name in the middle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                      if (!isAvailable)
                        const Text(
                          "Coming soon",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                    ],
                  ),
                ),
                // Radio on the right (only visible/active for available methods)
                if (isAvailable)
                  Radio<PaymentMethod>(
                    value: method,
                    groupValue: controller.selectedMethod.value,
                    onChanged: (val) => controller.selectPayment(val!),
                    activeColor: Colors.green,
                  )
                else
                  const Icon(Icons.lock_outline, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
