import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_app/constants/constant.dart';
import 'package:grocery_app/controller/cart_controller.dart';
import 'package:grocery_app/controller/product_controller.dart';
import 'package:grocery_app/controller/review_controller.dart';
import 'package:grocery_app/controller/wishlist_controller.dart';
import 'package:grocery_app/utils/currency_format.dart';
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
  final WishlistController wishlistController = Get.put(WishlistController());
  final reviewController = Get.put(ReviewController());

  @override
  void initState() {
    super.initState();
    fetchData();
    reviewController.fetchReviews(widget.productId);
  }

  Future<void> fetchData() async {
    await Future.wait([
      cartController.fetchCart(),
      productController.fetchSingleProduct(productId: widget.productId),
      wishlistController.isInWishlist(productId: widget.productId),
    ]);
  }

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
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new),
                  onPressed: () {
                    Get.back();
                  },
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    // child: GestureDetector(
                    //   child: Icon(Icons.favorite_border),
                    //   onTap: () async {
                    //     await wishlistController.createWishList(proId: widget.productId);
                    //   },
                    // ),
                    child: IconButton(
                      onPressed: () async {
                        await wishlistController.toggleWishlist(productId: widget.productId);
                      },
                      icon: wishlistController.isInWishlistProduct.isTrue
                          ? Icon(Icons.favorite_outlined, color: Colors.red)
                          : Icon(Icons.favorite_border),
                    ),
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
                      // items.image.isNotEmpty
                      //     ? Image.network(items.image[0], width: double.infinity, height: 200)
                      //     : Icon(Icons.image_not_supported, color: Colors.grey),
                      Image.network(
                        items.image[0],
                        width: double.infinity,
                        height: 200,
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
                                  // "\$${items.finalPrice.toStringAsFixed(2)}",
                                  rielFormat.format(items.finalPrice),
                                  style: TextStyle(
                                    color: Constant.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  // "\$${items.price.toStringAsFixed(2)}",
                                  rielFormat.format(items.price),
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
                              // "\$${items.price.toStringAsFixed(2)}",
                              rielFormat.format(items.price),
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
                        title: Text(
                          (items.category?.name ?? 'Unknown Category'),
                          style: TextStyle(
                            color: Constant.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, size: 18),
                      ),
                      // ReviewTile(rating: 4.5, totalReviews: 120),
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Text(
                      //       "Reviews",
                      //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      //     ),
                      //     Obx(() {
                      //       if (reviewController.isLoading.value) {
                      //         return Center(child: CircularProgressIndicator());
                      //       }
                      //       if (reviewController.reviews.isEmpty) {
                      //         return Text("No reviews yet", style: TextStyle(color: Colors.grey));
                      //       }
                      //       return Column(
                      //         children: reviewController.reviews
                      //             .map((review) => ReviewTile(rating: review.rating))
                      //             .toList(),
                      //       );
                      //     }),
                      //   ],
                      // ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Reviews",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Constant.primaryColor,
                            ),
                          ),
                          Obx(() {
                            if (reviewController.isLoading.value) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (reviewController.reviews.isEmpty) {
                              return Text("No reviews yet", style: TextStyle(color: Colors.grey));
                            }

                            // Show up to 3 latest reviews
                            // final reviewsToShow = reviewController.reviews.take(3).toList();
                            final reviewsToShow = reviewController.filteredReviews
                                .take(10)
                                .toList();

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _filterChips(reviewController),

                                if (reviewsToShow.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 20),
                                    child: Center(
                                      child: Text(
                                        "No reviews yet",
                                        style: TextStyle(color: Colors.grey, fontSize: 14),
                                      ),
                                    ),
                                  )
                                else
                                  ...reviewsToShow.map(
                                    (review) => ReviewTile(
                                      rating: review.rating,
                                      userName: review.userName,
                                      comment: review.comment,
                                    ),
                                  ),
                              ],
                            );
                          }),
                          SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              // Navigate to a full review page
                              // Get.to(() => AllReviewsPage(productId: widget.productId));
                            },
                            child: Text("See all reviews"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(20.0),
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

class ReviewChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const ReviewChip({super.key, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      backgroundColor: Colors.transparent,
      // selectedColor: Colors.transparent,
      disabledColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      selectedColor: Constant.primaryColor.withOpacity(0.15),
      labelStyle: TextStyle(
        color: selected ? Constant.primaryColor : Colors.black,
        fontWeight: FontWeight.w500,
      ),
      shape: StadiumBorder(
        side: BorderSide(
          color: selected ? Constant.primaryColor : Colors.grey.shade400,
          width: 1.5,
        ),
      ),
    );
  }
}

Widget _filterChips(ReviewController controller) {
  return Obx(() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Wrap(
        spacing: 8,
        children: [
          ReviewChip(
            label: 'All (${controller.reviews.length})',
            selected: controller.selectedRating.value == 0,
            onTap: () => controller.setRatingFilter(0),
          ),
          ReviewChip(
            label: '5 ⭐ (${controller.countByRating(5)})',
            selected: controller.selectedRating.value == 5,
            onTap: () => controller.setRatingFilter(5),
          ),
          ReviewChip(
            label: '4 ⭐ (${controller.countByRating(4)})',
            selected: controller.selectedRating.value == 4,
            onTap: () => controller.setRatingFilter(4),
          ),
          ReviewChip(
            label: '3 ⭐ (${controller.countByRating(3)})',
            selected: controller.selectedRating.value == 3,
            onTap: () => controller.setRatingFilter(3),
          ),
          ReviewChip(
            label: '2 ⭐ (${controller.countByRating(2)})',
            selected: controller.selectedRating.value == 2,
            onTap: () => controller.setRatingFilter(2),
          ),
          ReviewChip(
            label: '1 ⭐ (${controller.countByRating(1)})',
            selected: controller.selectedRating.value == 1,
            onTap: () => controller.setRatingFilter(1),
          ),
        ],
      ),
    );
  });
}
