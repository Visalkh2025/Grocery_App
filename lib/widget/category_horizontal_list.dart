import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_app/controller/product_controller.dart';
import 'package:grocery_app/models/category.dart';
import 'package:grocery_app/models/product.dart';
import 'package:grocery_app/pages/category_item_page.dart';

class CategoryHorizontalList extends StatelessWidget {
  final List gridColor;
  final List<Category> items;
  final List<Product> products;

  const CategoryHorizontalList({
    super.key,
    required this.gridColor,
    required this.items,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    // final productController = Get.put(ProductController());

    return Obx(
      () => SizedBox(
        height: 130,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(width: 20),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Get.to(
                  () => CategoryItemPage(category: items[index]),
                  transition: Transition.rightToLeft,
                );
              },
              child: Column(
                children: [
                  Container(
                    height: 90,
                    width: 90,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: gridColor[index % gridColor.length].withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: gridColor[index % gridColor.length].withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Image.network(items[index].image),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    items[index].name,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
