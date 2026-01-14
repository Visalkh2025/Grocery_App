import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_app/constants/constant.dart';
import 'package:grocery_app/controller/cart_controller.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/pages/cart_page.dart';
import 'package:grocery_app/pages/explore_page.dart';
import 'package:grocery_app/pages/main_page.dart';
import 'package:grocery_app/pages/order_accepted_page.dart';
import 'package:grocery_app/pages/payment_page.dart';
import 'package:grocery_app/utils/currency_format.dart';
import 'package:grocery_app/widget/primary_button.dart';
import 'package:icons_plus/icons_plus.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late final CartController cartController = Get.put(CartController());
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back_ios_new)),
          title: Text("Checkout", style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
        ),

        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 10),

              Obx(() {
                final items = cartController.cart.value.items;
                return ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Product image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              children: [
                                Container(
                                  color: const Color(0xffF4F5F6),
                                  child: Image.network(
                                    item.product?.image.first ?? '',
                                    width: 95,
                                    height: 95,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: const Icon(
                                          Icons.image_not_supported,
                                          size: 100,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                // Quantity badge
                                Positioned(
                                  right: 6,
                                  top: 6,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black87,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "x${item.quantity}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 14),

                          // Product info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product?.name ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  // "\$${item.product?.finalPrice.toStringAsFixed(2)}",
                                  rielFormat.format(item.product?.finalPrice),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Constant.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 10),
                );
              }),

              SizedBox(height: 15),

              // Promo code section
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: cartController.promoCodeController.value,
                      decoration: InputDecoration(
                        hintText: "Discount code",
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.black12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.black12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.black26),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  ElevatedButton(
                    onPressed: () => cartController.applyPromoCode(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constant.primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(70, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Apply"),
                  ),

                  const SizedBox(width: 4),

                  IconButton(
                    onPressed: () => cartController.cancelPromoCode(),
                    icon: const Icon(Icons.close),
                    color: Colors.redAccent,
                    tooltip: "Cancel promo",
                  ),
                ],
              ),

              // Summary section - separate Obx
              Obx(() {
                final summaryItems = cartController.getSummaryItems();
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: summaryItems.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        summaryItems[index]['title'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: summaryItems[index]["bold"] == true
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      trailing: Text(
                        summaryItems[index]["editable"] == true
                            ? "Enter Shipping address"
                            // : "\$${summaryItems[index]["amount"]}",
                            : rielFormat.format(summaryItems[index]["amount"]),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: summaryItems[index]["bold"] == true
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    );
                  },
                );
              }),

              SizedBox(height: 100),
            ],
          ),
        ),
        bottomSheet: Container(
          padding: EdgeInsets.all(20),
          child: PrimaryButton(
            text: "Order now",
            onPressed: () {
              cartController.checkoutCart();
            },
          ),
        ),
      ),
    );
  }
}
