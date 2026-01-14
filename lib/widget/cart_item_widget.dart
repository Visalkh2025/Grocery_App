import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:grocery_app/constants/constant.dart';
import 'package:grocery_app/controller/cart_controller.dart';
import 'package:grocery_app/controller/wishlist_controller.dart';
import 'package:grocery_app/models/product.dart';
import 'package:grocery_app/pages/detail_product_page.dart';
import 'package:grocery_app/utils/currency_format.dart';

class CartItemWidget extends StatelessWidget {
  final Product product;
  const CartItemWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.put(CartController());

    return GestureDetector(
      onTap: () {
        log("Tapped on product: ${product.id}");
        Get.to(() => DetailProductPage(productId: product.id));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                        // child: product.image.isNotEmpty
                        //     ? Image.network(product.image[0], fit: BoxFit.contain)
                        //     : Icon(Icons.image_not_supported, color: Colors.grey),
                        // child: Image.network(
                        //   product.image.first,
                        //   fit: BoxFit.contain,
                        //   // loadingBuilder: (context, child, loadingProgress) {
                        //   //   if (loadingProgress == null) return child;
                        //   //   return const Center(child: CircularProgressIndicator());
                        //   // },
                        //   errorBuilder: (context, error, stackTrace) {
                        //     return const Icon(Icons.image_not_supported, color: Colors.grey);
                        //   },
                        // ),
                        child: CachedNetworkImage(
                          imageUrl: product.image.first,
                          fit: BoxFit.contain,
                          errorWidget: (context, error, stackTrace) {
                            return const Icon(Icons.image_not_supported, color: Colors.grey);
                          },
                        ),
                      ),
                    ),
                  ),
                  if (product.finalPrice < product.price)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "${product.discount}%",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    product.description ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      if (product.finalPrice < product.price)
                        Row(
                          children: [
                            Text(
                              // "\$${product.finalPrice.toStringAsFixed(2)}",
                              rielFormat.format(product.finalPrice),
                              style: TextStyle(
                                color: Constant.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              // "\$${product.price.toStringAsFixed(2)}",
                              rielFormat.format(product.price),
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
                          // "\$${product.price.toStringAsFixed(2)}",
                          rielFormat.format(product.price),
                          style: TextStyle(
                            color: Constant.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      Container(
                        width: 35,
                        height: 35,
                        // padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Constant.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.add, color: Colors.white),
                            onPressed: () {
                              log('PRODUCT: ${product.id}');
                              cartController.createCart(productId: product.id ?? '');
                            },
                          ),
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
}
