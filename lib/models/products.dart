class Products {
  final int? id;
  final String name;
  final String description;
  final double price;
  final String imagePath;

  Products({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
  });
}

var items = [
  Products(
    id: 1,
    name: "Cambodia Beer",
    description: "330ml, Can",
    price: 2.69,
    imagePath: "assets/images/grocery_images/beverages_cam-bottle.jpg",
  ),
  Products(
    id: 2,
    name: "Cambodia Beer",
    description: "390ml, Bottle",
    price: 4.99,
    imagePath: "assets/images/grocery_images/beverages_cam-dark-beer.png",
  ),
  Products(
    id: 3,
    name: "Coca",
    description: "330ml, Can",
    price: 4.99,
    imagePath: "assets/images/grocery_images/cola.webp",
  ),
];
