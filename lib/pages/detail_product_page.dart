import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_app/constants/constant.dart';
import 'package:grocery_app/controller/cart_controller.dart';
import 'package:grocery_app/controller/product_controller.dart';
import 'package:grocery_app/widget/custom_button.dart';
import 'package:grocery_app/widget/custom_expansion_Tile.dart';
import 'package:grocery_app/widget/review__tile.dart';

class DetailProductPage extends StatefulWidget {
  final String productId;
  const DetailProductPage({super.key, required this.productId});

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  // final cartController = Get.put(CartController());
  // final wishlistController = Get.put(WishlistController());
  final productController = Get.put(ProductController());
  final CartController cartController = Get.put(CartController());

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await Future.wait([
      cartController.fetchCart(),
      productController.fetchSingleProduct(productId: widget.productId),
      // wishlistController.isInWishlist(productId: widget.productId),
    ]);
  }

  // void _createCart() async {
  //   await cartController.createCart(productId: widget.productId);
  // }

  // void increase() async {
  //   // Check if not in cart, then create cart item
  //   if (cartController.cart.value.items.every((item) => item.product?.id != widget.productId)) {
  //     await cartController.createCart(productId: widget.productId);
  //     // Don't return here - let it continue so the state updates
  //     // Or explicitly wait for the state to update:
  //     // return; // Remove this line
  //   } else {
  //     await cartController.updateQuantity(productId: widget.productId, quantity: 1);
  //   }
  // }
  Future<void> increase() async {
    // Check if item exists in cart
    final itemExists = cartController.cart.value.items.any(
      (item) => item.product?.id == widget.productId,
    );

    if (!itemExists) {
      // Create new cart item
      await cartController.createCart(productId: widget.productId);
    } else {
      // Update existing item
      await cartController.updateQuantity(productId: widget.productId, quantity: 1);
    }
  }

  void decrease() async {
    await cartController.updateQuantity(productId: widget.productId, quantity: -1);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = productController.selectProduct.value;
      // final cartItems = cartController.cart.value.items.where(
      //   (item) => item.product!.id == items!.id,
      // );

      // final quantity = cartItems.isNotEmpty ? cartItems.first.quantity : 0;
      // final cartItem = cartController.cart.value.items.firstWhereOrNull(
      //   (item) => item.product?.id == items!.id,
      // );
      // final quantity = cartItem?.quantity ?? 0;
      final cart = cartController.cart.value;
      final cartItems = cart?.items ?? [];
      final cartItem = cartItems.firstWhereOrNull((item) => item.product?.id == items?.id);
      final quantity = cartItem?.quantity ?? 0;

      if (productController.isSingleProductLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      if (items == null) {
        return const Scaffold(body: Center(child: Text("Product not found")));
      }
      return productController.isSingleProductLoading.isTrue
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.favorite_border),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(items.image[0], width: double.infinity, height: 200),
                      Text(items.name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      Text(items.description ?? '', style: TextStyle(color: Constant.subTitle)),
                      SizedBox(height: 10),
                      Row(
                        spacing: 10,
                        children: [
                          CustomButton(
                            icon: Icons.remove,
                            onTap: () {
                              decrease();
                            },
                            backgroundColor: Constant.subTitle,
                          ),

                          Text(
                            // "${cartController.cart.value.items.firstWhere((item) => item.product!.id == items.id).quantity}",
                            quantity.toString(),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          CustomButton(
                            icon: Icons.add,
                            onTap: () {
                              increase();
                            },
                          ),
                          Spacer(),
                          if (items.finalPrice < items.price)
                            Row(
                              children: [
                                Text(
                                  "\$${items.finalPrice.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    color: Constant.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "\$${items.price.toStringAsFixed(2)}",
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
                              "\$${items.price.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: Constant.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Divider(
                        radius: BorderRadius.circular(50),
                        color: Colors.grey.shade300,
                        thickness: 2,
                      ),

                      CustomExpansionTile(
                        title: "Product Details",
                        content:
                            items.description ??
                            'This organic avocado is fresh, locally grown, and handpicked for the best quality. Store in a cool, dry place.',
                      ),

                      ListTile(
                        title: Text((items.category?.name ?? 'Unknown Category')),
                        trailing: Icon(Icons.arrow_forward_ios, size: 18),
                      ),
                      ReviewTile(rating: 4.5, totalReviews: 120),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(50.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Constant.primaryColor),
                    onPressed: increase,
                    child: Text("Add to Cart", style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
              ),
            );
    });
  }
}
