import 'package:flutter/material.dart';
import 'package:grocery_app/models/category_item.dart';
import 'package:grocery_app/models/grocery_item.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for categories - REPLACE 'imagePath' with your actual assets
   List gridColor = [
    Color(0xff53B175),
    Color(0xffF8a44C),
    Color(0xffF7A593),
    Color(0xffD3B0E0),
    Color(0xffFDE598),
    Color(0xffB7DFF5),
    Color(0xff836AF6),
    Color(0xffD73B77),
  ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            "Shop categories",
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold,
              color: Colors.black87
            ),
          ),
        ),
        
        // Horizontal List
        SizedBox(
          height: 140, // Height for image box + text
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: categoryItemDemo.length,
            separatorBuilder: (_, __) => const SizedBox(width: 15),
            itemBuilder: (context, index) {
              final cat = categoryItemDemo[index];
              return Column(
                children: [
                  // Image Container
                  Container(
                    width: 85,
                    height: 85,
                    padding: const EdgeInsets.all(15), // padding around image
                   decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: gridColor[index % gridColor.length].withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                        color: gridColor[index % gridColor.length].withValues(alpha: 0.2),
                      ),
                    child: Image.asset(
                      cat.imgPath,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Category Name
                  SizedBox(
                    width: 85,
                    child: Text(
                      cat.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}