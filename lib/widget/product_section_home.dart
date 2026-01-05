import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_app/constants/constant.dart';
import 'package:grocery_app/controller/product_controller.dart';
import 'package:grocery_app/widget/cart_item_widget.dart';

class ProductSectionHome extends StatelessWidget {
  final String title;
  final String sort;
  const ProductSectionHome({super.key, required this.title, required this.sort});

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.put(ProductController(sort: sort), tag: sort);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Container(
                    height: 3,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Constant.primaryColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Text(
                    "See all",
                    style: TextStyle(
                      fontSize: 16,
                      color: Constant.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios, size: 14, color: Constant.primaryColor),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Obx(() => _horizontalItemList(controller)),
      ],
    );
  }
}

Widget _horizontalItemList(ProductController productController) {
  final product = productController.products;

  return SizedBox(
    height: 260,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: product.length,
      separatorBuilder: (_, __) => const SizedBox(width: 15),
      itemBuilder: (_, index) {
        return SizedBox(width: 170, child: CartItemWidget(product: product[index]));
      },
    ),
  );
}
