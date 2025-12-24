import 'package:flutter/cupertino.dart';

class CategoryItem {
  final int? id;
  final String name;
  final String imgPath;
  
  CategoryItem({this.id, required this.name, required this.imgPath,});
}

var categoryItemDemo = [
  CategoryItem(
    name: "Fruit & Vegetable",
    imgPath: "assets/images/categories_images/fruit.png",
  ),
  CategoryItem(name: "Cooking Oil", imgPath: "assets/images/categories_images/oil.png",),
  CategoryItem(name: "Meat and Fish", imgPath: "assets/images/categories_images/meat.png"),
  CategoryItem(name: "Bakery & Snack", imgPath: "assets/images/categories_images/bakery.png"),
  CategoryItem(name: "Dairy & Condiments", imgPath: "assets/images/categories_images/dairy.png"),
  CategoryItem(name: "Beverages", imgPath: "assets/images/categories_images/beverages.png"),
];
