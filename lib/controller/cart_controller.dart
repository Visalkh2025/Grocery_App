import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:grocery_app/models/cart.dart';
import 'package:grocery_app/pages/payment_page.dart';
import 'package:grocery_app/service/api/cart_service.dart';

class CartController extends GetxController {
  final CartService cartService = CartService();
  Rx<Cart> cart = Cart.empty().obs;
  final discount = 0.0.obs;
  final promoCodeController = TextEditingController().obs;
  final total = 0.0.obs;
  final appliedPromo = Rx<Map<String, dynamic>?>(null);

  final isLoadingFetchCard = false.obs;

  @override
  void onInit() {
    fetchCart();
    _recalculateDiscount();

    super.onInit();
  }

  Future<void> clearCart() async {
    cart.value.items.clear();
    cart.refresh();
  }

  final subTotal = 0.0.obs;

  Future<void> getSubTotal() async {
    double total = 0.0;
    for (var item in cart.value.items) {
      final price = item.product?.finalPrice ?? 0.0;
      total += item.quantity * price;
    }
    subTotal.value = total;
    _recalculateDiscount();
  }

  void cancelPromoCode() {
    // Clear text field
    promoCodeController.value.clear();
    // Reset discount
    discount.value = 0.0;
    getSubTotal();
    appliedPromo.value = null;

    log("Promo cancelled — prices reset to normal");
  }

  // Future<void> applyPromoCode() async {
  //   if (promoCodeController.value.text.isEmpty) return;

  //   await getSubTotal();

  //   final result = await cartService.applyPromoCode(promoCodeController.value.text);
  //   if (result?['discountType'] == "percentage") {
  //     final discountValue = (result?["discountValue"] ?? 0).toDouble();
  //     discount.value = discountValue / 100 * subTotal.value;
  //   } else if (result?['discountType'] == "fixed") {
  //     discount.value = (result?["discountValue"] ?? 0).toDouble();
  //   }
  // }

  Future<void> applyPromoCode() async {
    if (promoCodeController.value.text.isEmpty) return;

    await getSubTotal();

    final result = await cartService.applyPromoCode(promoCodeController.value.text);

    appliedPromo.value = result; //remember promo

    _recalculateDiscount();
  }

  void _recalculateDiscount() {
    if (appliedPromo.value == null) {
      discount.value = 0;
      return;
    }

    final promo = appliedPromo.value!;

    if (promo['discountType'] == "percentage") {
      final discountValue = (promo["discountValue"] ?? 0).toDouble();
      discount.value = discountValue / 100 * subTotal.value;
    } else if (promo['discountType'] == "fixed") {
      discount.value = (promo["discountValue"] ?? 0).toDouble();
    }
  }

  List<Map<String, dynamic>> getSummaryItems() {
    double shipping = 0.0;
    double estimatedTaxes = 0.0;
    double otherfee = 0.0;
    double total = shipping + estimatedTaxes + otherfee + subTotal.value;
    total -= discount.value;
    String format(double value) => value.toStringAsFixed(2);
    return [
      {"title": "Subtotal", "amount": format(subTotal.value)},
      // {"title": "Address", "amount": format(shipping), "editable": true},
      {"title": "Estimated Taxes", "amount": format(estimatedTaxes)},
      {"title": "Others Fees", "amount": format(otherfee)},
      {"title": "Discount", "amount": format(discount.value)},
      {"title": "Total", "amount": format(total), "bold": true},
    ];
  }

  Future<void> createCart({required String productId}) async {
    await cartService.createCard(productId: productId);
    await fetchCart();
  }

  Future<void> fetchCart() async {
    isLoadingFetchCard(true);
    final data = await cartService.fetchCard();
    cart.value = data;
    await getSubTotal();
    isLoadingFetchCard(false);
  }

  Future<void> updateQuantity({required String productId, required int quantity}) async {
    int index = cart.value.items.indexWhere((item) => item.product!.id == productId);

    if (index != -1) {
      final currentQty = cart.value.items[index].quantity;
      final newQty = currentQty + quantity;

      if (newQty < 1) return;

      cart.value.items[index].quantity = newQty;
      cart.refresh();

      await cartService.updateQuantity(productId: productId, quantity: newQty);
      await getSubTotal();
    }
  }

  Future<void> removeItem({required String productId}) async {
    int index = cart.value.items.indexWhere((item) => item.product!.id == productId);

    if (index != -1) {
      cart.value.items.removeAt(index);
      cart.refresh();
    }
    await cartService.removeItem(productId: productId);
    getSubTotal();
  }

  Future<void> checkoutCart() async {
    try {
      isLoadingFetchCard(true);
      final totalAmount = double.tryParse(getSummaryItems().last['amount'].toString()) ?? 0.0;

      final items = cart.value.items
          .map(
            (e) => {
              "productId": e.product!.id,
              "quantity": e.quantity,
              "price": e.product!.finalPrice,
              "subTotal": (e.product!.finalPrice) * (e.quantity),
            },
          )
          .toList();

      final res = await cartService.checkout(
        totalAmount: totalAmount,
        promoCode: promoCodeController.value.text,
        items: items,
      );

      if (res != null && res['orderId'] != null) {
        final orderId = res['orderId'];
        log("Order created: $orderId");

        // Navigate to payment page
        Get.to(() => PaymentPage(orderId: orderId));
      } else {
        Get.snackbar("Error", res?['message'] ?? "Failed to create order");
      }
    } catch (e) {
      log("Checkout error: $e");
      Get.snackbar("Error", "Something went wrong during checkout");
    } finally {
      isLoadingFetchCard(false);
    }
  }
}
