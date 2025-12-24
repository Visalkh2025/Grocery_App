import 'package:flutter/material.dart';
import 'package:grocery_app/pages/filter_page.dart';
import 'package:grocery_app/models/products.dart';
import 'package:grocery_app/widget/cart_item_widget.dart';

class CategoryItemPage extends StatefulWidget {
  final String categoryName;
  const CategoryItemPage({super.key, required this.categoryName});

  @override
  State<CategoryItemPage> createState() => _CategoryItemPageState();
}

class _CategoryItemPageState extends State<CategoryItemPage> {
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
          widget.categoryName,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: GridView.builder(
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.6,
          ),
          itemBuilder: (context, index) {
            return CartItemWidget(item: items[index]);
          },
        ),
      ),
    );

  }
}
