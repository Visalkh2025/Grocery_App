import 'package:flutter/material.dart';
import 'package:grocery_app/constants/constant.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/widget/custom_button.dart';
import 'package:grocery_app/widget/custom_expansion_Tile.dart';
import 'package:grocery_app/widget/review__tile.dart';

class DetailProductPage extends StatefulWidget {
  final GroceryItem items;
  const DetailProductPage({super.key, required this.items});

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Image.asset(widget.items.imagePath, width: double.infinity, height: 200),
              Text(widget.items.name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text(widget.items.description, style: TextStyle(color: Constant.subTitle)),
              SizedBox(height: 10),
              Row(
                spacing: 10,
                children: [
                  CustomButton(
                    icon: Icons.remove,
                    onTap: () {},
                    backgroundColor: Constant.subTitle,
                  ),
                  Text(
                    "0",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  CustomButton(icon: Icons.add, onTap: () {}),
                  Spacer(),
                  Text("\$${widget.items.price.toStringAsFixed(2)}"),
                ],
              ),
              SizedBox(height: 30),
              Divider(radius: BorderRadius.circular(50), color: Colors.grey.shade300, thickness: 2),

              CustomExpansionTile(
                title: "Product Details",
                content:
                    "This organic avocado is fresh, locally grown, and handpicked for the best quality. Store in a cool, dry place.",
              ),

              ListTile(
                title: Text("Nutritions"),
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
            onPressed: () {},
            child: Text("Add to Cart", style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
