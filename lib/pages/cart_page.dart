// import 'package:flutter/material.dart';
// import 'package:grocery_app/constants/constant.dart';
// import 'package:grocery_app/models/grocery_item.dart';
// import 'package:grocery_app/pages/checkout_page.dart';

// class CartItem {
//   final GroceryItem item;
//   int quantity;

//   CartItem({required this.item, this.quantity = 1});
// }

// class CartPage extends StatefulWidget {
//   const CartPage({super.key});

//   @override
//   State<CartPage> createState() => _CartPageState();
// }

// class _CartPageState extends State<CartPage> {
//   late List<CartItem> _cartItems;

//   @override
//   void initState() {
//     super.initState();

//     _cartItems = items.map((e) => CartItem(item: e, quantity: 1)).toList();
//   }

//   double get _totalPrice {
//     return _cartItems.fold(0, (sum, e) => sum + (e.item.price * e.quantity));
//   }

//   void _removeItem(int index) {
//     setState(() {
//       _cartItems.removeAt(index);
//     });
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(const SnackBar(content: Text("Item removed"), duration: Duration(seconds: 1)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         // leading: IconButton(
//         //   icon: const Icon(
//         //     Icons.arrow_back_ios_new,
//         //     color: Colors.black,
//         //     size: 20,
//         //   ),
//         //   onPressed: () => Navigator.pop(context),
//         // ),
//         title: Column(
//           children: [
//             const Text(
//               "My Cart",
//               style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//             ),
//             if (_cartItems.isNotEmpty)
//               Text(
//                 "${_cartItems.length} items",
//                 style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
//               ),
//           ],
//         ),
//       ),
//       body: _cartItems.isEmpty ? _buildEmptyState() : _buildCartContent(),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey.shade300),
//           const SizedBox(height: 20),
//           const Text(
//             "Your cart is empty",
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 10),
//           const Text(
//             "Looks like you haven't added\nany items to the cart yet.",
//             textAlign: TextAlign.center,
//             style: TextStyle(color: Colors.grey),
//           ),
//           const SizedBox(height: 30),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Constant.primaryColor,
//               padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//             ),
//             child: const Text("Start Shopping", style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCartContent() {
//     return Column(
//       children: [
//         Expanded(
//           child: ListView.separated(
//             padding: const EdgeInsets.all(20),
//             itemCount: _cartItems.length,
//             separatorBuilder: (_, __) => const SizedBox(height: 15),
//             itemBuilder: (context, index) {
//               final cartItem = _cartItems[index];
//               return _buildCartItem(cartItem, index);
//             },
//           ),
//         ),
//         _buildBottomSection(),
//       ],
//     );
//   }

//   Widget _buildCartItem(CartItem cartItem, int index) {
//     return Dismissible(
//       key: Key(cartItem.item.name),
//       direction: DismissDirection.endToStart,
//       background: Container(
//         padding: const EdgeInsets.only(right: 20),
//         decoration: BoxDecoration(
//           color: Colors.red.shade100,
//           borderRadius: BorderRadius.circular(15),
//         ),
//         alignment: Alignment.centerRight,
//         child: const Icon(Icons.delete_outline, color: Colors.red, size: 30),
//       ),
//       onDismissed: (direction) => _removeItem(index),
//       child: Container(
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               blurRadius: 10,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 80,
//               height: 80,
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade50,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Image.asset(cartItem.item.imagePath, fit: BoxFit.contain),
//             ),
//             const SizedBox(width: 15),

//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         cartItem.item.name,
//                         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                       IconButton(
//                         onPressed: () => _removeItem(index),
//                         icon: Icon(Icons.close, color: Colors.grey.shade400, size: 18),
//                         visualDensity: VisualDensity.compact,
//                       ),
//                     ],
//                   ),
//                   Text(
//                     cartItem.item.description,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
//                   ),
//                   const SizedBox(height: 10),

//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "\$${cartItem.item.price.toStringAsFixed(2)}",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Constant.primaryColor,
//                         ),
//                       ),

//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade100,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Row(
//                           children: [
//                             _quantityBtn(
//                               icon: Icons.remove,
//                               onTap: () {
//                                 if (cartItem.quantity > 1) {
//                                   setState(() => cartItem.quantity--);
//                                 }
//                               },
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 10),
//                               child: Text(
//                                 "${cartItem.quantity}",
//                                 style: const TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             _quantityBtn(
//                               icon: Icons.add,
//                               color: Constant.primaryColor,
//                               isActive: true,
//                               onTap: () {
//                                 setState(() => cartItem.quantity++);
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _quantityBtn({
//     required IconData icon,
//     required VoidCallback onTap,
//     Color? color,
//     bool isActive = false,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         width: 28,
//         height: 28,
//         decoration: BoxDecoration(
//           color: isActive ? Colors.white : Colors.transparent,
//           shape: BoxShape.circle,
//           boxShadow: isActive
//               ? [BoxShadow(color: Colors.black12, blurRadius: 2, spreadRadius: 1)]
//               : null,
//         ),
//         child: Icon(icon, size: 16, color: color ?? Colors.grey),
//       ),
//     );
//   }

//   Widget _buildBottomSection() {
//     double deliveryFee = 2.00;
//     double finalTotal = _totalPrice + deliveryFee;

//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 20,
//             offset: const Offset(0, -5),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             _summaryRow("Subtotal", _totalPrice),
//             const SizedBox(height: 10),
//             _summaryRow("Delivery Fee", deliveryFee),
//             const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Divider(height: 1)),

//             // _summaryRow("Total", finalTotal, isTotal: true),

//             // const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               height: 55,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const CheckoutPage()),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Constant.primaryColor,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                   elevation: 5,
//                   shadowColor: Constant.primaryColor.withOpacity(0.4),
//                 ),
//                 child: Text(
//                   "Proceed to Checkout (\$${finalTotal.toStringAsFixed(2)})",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _summaryRow(String title, double amount, {bool isTotal = false}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             color: isTotal ? Colors.black : Colors.grey.shade600,
//             fontSize: isTotal ? 18 : 14,
//             fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//           ),
//         ),
//         Text(
//           "\$${amount.toStringAsFixed(2)}",
//           style: TextStyle(
//             color: isTotal ? Colors.black : Colors.black,
//             fontSize: isTotal ? 18 : 14,
//             fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_app/constants/constant.dart';
import 'package:grocery_app/controller/cart_controller.dart';
import 'package:grocery_app/pages/checkout_page.dart';
import 'package:grocery_app/pages/home_page.dart';
import 'package:grocery_app/pages/main_page.dart';
import 'package:grocery_app/utils/currency_format.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartController cartCtrl = Get.put(CartController());

  double subtotal() {
    final items = cartCtrl.cart.value.items;
    double total = 0;

    for (var i in items) {
      final price = i.product?.finalPrice ?? 0;
      total += price * (i.quantity);
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
        // title: Obx(() {
        //   final count = cartCtrl.cart.value.items.length;

        //   return Column(
        //     children: [
        //       const Text(
        //         "My Cart",
        //         style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        //       ),
        //       if (count > 0)
        //         Text("$count items", style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
        //     ],
        //   );
        // }),
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
                              "\$${item.product.finalPrice.toStringAsFixed(2)}",
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
                          "\$${item.product.price.toStringAsFixed(2)}",
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
    const deliveryFee = 0.0;

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
                    "Proceed to Checkout (\$${total.toStringAsFixed(2)})",
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

  Widget _summaryRow(String title, double amount, {bool isTotal = false}) {
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
          "\$${amount.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
