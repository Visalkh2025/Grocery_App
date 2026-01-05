import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_app/controller/product_controller.dart';
import 'package:grocery_app/models/category.dart';
import 'package:grocery_app/pages/filter_page.dart';
import 'package:grocery_app/models/products.dart';
import 'package:grocery_app/widget/cart_item_widget.dart';
import 'package:grocery_app/widget/loading-widget/loading_card_widget.dart';
import 'package:grocery_app/widget/loading-widget/loading_gird_widget.dart';

class CategoryItemPage extends StatefulWidget {
  // final String categoryName;
  final Category category;
  const CategoryItemPage({super.key, required this.category});

  @override
  State<CategoryItemPage> createState() => _CategoryItemPageState();
}

class _CategoryItemPageState extends State<CategoryItemPage> {
  final productController = Get.put(ProductController());

  @override
  void initState() {
    super.initState();
    productController.fetchProductsByCategory(categoryId: widget.category.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              icon: Icon(Icons.sort_sharp),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => (FilterPage())));
              },
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(
          widget.category.name,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Obx(() {
          if (productController.isProductByCateLoading.value) {
            return const CircularProgressIndicator();
          }

          if (productController.products.isEmpty) {
            return const Center(child: Text("No products found"));
          }

          return GridView.builder(
            itemCount: productController.products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.6,
            ),
            itemBuilder: (context, index) {
              return CartItemWidget(product: productController.products[index]);
            },
          );
        }),
      ),
    );
  }
}
