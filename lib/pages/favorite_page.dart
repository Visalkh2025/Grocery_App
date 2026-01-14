import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_app/constants/constant.dart';
import 'package:grocery_app/controller/cart_controller.dart';
import 'package:grocery_app/controller/product_controller.dart';
import 'package:grocery_app/controller/wishlist_controller.dart';
import 'package:grocery_app/models/wishlist.dart';
import 'package:grocery_app/utils/currency_format.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  // late List<GroceryItem> _favoriteItems;
  final WishlistController wishlistController = Get.put(WishlistController());
  final ProductController productController = Get.put(ProductController());
  final CartController cartController = Get.put(CartController());

  @override
  void initState() {
    super.initState();
    wishlistController.fetchWishlist();

    // _favoriteItems = List.from(beverages);
  }

  void _removeItem(String? productId) async {
    if (productId == null) return;
    await wishlistController.removeWishlist(productId: productId);
  }

  void _clearAll() {}

  void _addToCart(String? productId) async {
    if (productId == null) return;
    await cartController.createCart(productId: productId);
    await wishlistController.removeWishlist(productId: productId);
    await wishlistController.fetchWishlist();
  }

  void _addAllToCart() async {
    // not do
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
          "Favorite",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Obx(() {
            return wishlistController.wishlist.value.items.isNotEmpty
                ? TextButton(
                    onPressed: _clearAll,
                    child: const Text(
                      "Clear",
                      style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
                    ),
                  )
                : SizedBox();
          }),
        ],
      ),
      // body: _favoriteItems.isEmpty ? _buildEmptyState() : _buildContent(),
      body: Obx(() {
        if (wishlistController.isLoading.isTrue) {
          return Center(child: CircularProgressIndicator());
        } else if (wishlistController.wishlist.value.items.isEmpty) {
          return _buildEmptyState();
        } else {
          return _buildContent();
        }
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 100, color: Colors.grey.shade300),
          const SizedBox(height: 20),
          const Text(
            "Your wishlist is empty",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            "Save your favorite items here\nto checkout later.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        const SizedBox(height: 10),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            itemCount: wishlistController.wishlist.value.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 15),
            itemBuilder: (context, index) {
              // final item = _favoriteItems[index];
              final Item items = wishlistController.wishlist.value.items[index];

              return _buildFavoriteItem(items, index);
            },
          ),
        ),
        // _buildBottomButton(),
      ],
    );
  }

  Widget _buildFavoriteItem(Item item, int index) {
    return Dismissible(
      key: Key(item.product!.name),
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
      onDismissed: (direction) => _removeItem(item.product!.id),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
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

              child: item.product!.image.isNotEmpty
                  ? Image.network(
                      item.product!.image.first,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image_not_supported, color: Colors.grey);
                      },
                    )
                  : const Icon(Icons.image_not_supported, color: Colors.grey, size: 40),
            ),
            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product!.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  // Text(
                  //   // item.product!.description,
                  //   maxLines: 1,
                  //   overflow: TextOverflow.ellipsis,
                  //   style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  // ),
                  const SizedBox(height: 8),
                  Text(
                    rielFormat.format(item.product!.finalPrice),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Constant.primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            IconButton(
              onPressed: () {
                _addToCart(item.product!.id);
              },

              icon: Icon(Icons.shopping_bag_outlined, color: Constant.primaryColor, size: 28),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
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
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: _addAllToCart,
            style: ElevatedButton.styleFrom(
              backgroundColor: Constant.primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 5,
              shadowColor: Constant.primaryColor.withOpacity(0.4),
            ),
            child: const Text(
              "Add All To Cart",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
