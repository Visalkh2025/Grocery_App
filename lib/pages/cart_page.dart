import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_app/constants/constant.dart';
import 'package:grocery_app/controller/cart_controller.dart';
import 'package:grocery_app/pages/checkout_page.dart';
import 'package:grocery_app/utils/currency_format.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartController cartCtrl = Get.put(CartController());

  int subtotal() {
    final items = cartCtrl.cart.value.items;
    int total = 0;

    for (var i in items) {
      final price = (i.product?.finalPrice ?? 0).toInt();
      total += price * i.quantity;
    }

    return total;
  }

  @override
  void initState() {
    super.initState();
    cartCtrl.fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "My Cart",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: Obx(() {
        if (cartCtrl.isLoadingFetchCard.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = cartCtrl.cart.value.items;
        if (items.isEmpty) {
          return _buildEmptyState(context);
        }

        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 15),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _buildCartItem(item, index);
                },
              ),
            ),
            _buildBottomSection(context),
          ],
        );
      }),
    );
  }

  // ---------- UI PARTS ----------
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey.shade300),
          const SizedBox(height: 20),
          const Text(
            "Your cart is empty",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            "Looks like you haven't added\nany items yet.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildCartItem(item, int index) {
    return Dismissible(
      key: Key(item.id ?? "$index"),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete_outline, color: Colors.red, size: 30),
      ),
      onDismissed: (_) => cartCtrl.removeItem(productId: item.product!.id!),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.network(
                (item.product?.image != null && item.product!.image.isNotEmpty)
                    ? item.product!.image.first
                    : 'https://via.placeholder.com/150',
                errorBuilder: (context, error, stackTrace) {
                  return Center(child: const Icon(Icons.image_not_supported, color: Colors.grey));
                },
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 15),

            // Text + price + quantity
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.product?.name ?? "",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () => cartCtrl.removeItem(productId: item.product!.id!),
                        icon: Icon(Icons.close, color: Colors.grey.shade400, size: 18),
                      ),
                    ],
                  ),
                  Text(
                    item.product?.name ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (item.product.finalPrice < item.product.price)
                        Row(
                          children: [
                            Text(
                              // "\$${item.product.finalPrice.toStringAsFixed(2)}",
                              rielFormat.format(item.product.finalPrice),
                              style: TextStyle(
                                color: Constant.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              // "\$${item.product.price.toStringAsFixed(2)}",
                              rielFormat.format(item.product.price),
                              style: const TextStyle(
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          // "\$${item.product.price.toStringAsFixed(2)}",
                          rielFormat.format(item.product.price),
                          style: TextStyle(
                            color: Constant.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                      // Quantity buttons
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            _quantityBtn(
                              icon: Icons.remove,
                              onTap: () => cartCtrl.updateQuantity(
                                productId: item.product!.id!,
                                quantity: -1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "${item.quantity}",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            _quantityBtn(
                              icon: Icons.add,
                              color: Constant.primaryColor,
                              isActive: true,
                              onTap: () => cartCtrl.updateQuantity(
                                productId: item.product!.id!,
                                quantity: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quantityBtn({
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
    bool isActive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: isActive
              ? [BoxShadow(color: Colors.black12, blurRadius: 2, spreadRadius: 1)]
              : null,
        ),
        child: Icon(icon, size: 16, color: color ?? Colors.grey),
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    const deliveryFee = 0;

    return Obx(() {
      final total = subtotal() + deliveryFee;

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _summaryRow("Subtotal", subtotal()),
              const SizedBox(height: 10),
              _summaryRow("Delivery Fee", deliveryFee),
              const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Divider(height: 1)),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CheckoutPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constant.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text(
                    // "Proceed to Checkout (\$${total.toStringAsFixed(2)})",
                    "Proceed to Checkout (${rielFormat.format(total)})",

                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _summaryRow(String title, int amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isTotal ? Colors.black : Colors.grey.shade600,
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          // "\$${amount.toStringAsFixed(2)}",
          rielFormat.format(amount),
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
