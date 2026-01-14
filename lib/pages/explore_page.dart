import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_app/constants/constant.dart';
import 'package:grocery_app/controller/brand_controller.dart';
import 'package:grocery_app/controller/category_controller.dart';
import 'package:grocery_app/controller/product_controller.dart';
import 'package:grocery_app/models/category_item.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/pages/category_item_page.dart';
import 'package:grocery_app/pages/search_sort_page.dart';
import 'package:grocery_app/widget/brand_item_card.dart';
import 'package:grocery_app/widget/category_horizontal_list.dart';
import 'package:grocery_app/widget/search_widget.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

final BrandController brandController = Get.put(BrandController());
final CategoryController categoryController = Get.put(CategoryController());
final ProductController productController = Get.put(ProductController());

class _ExplorePageState extends State<ExplorePage> {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Find Products",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SearchWidget(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => SearchSortPage()),
                    // );
                    Get.to(() => SearchSortPage());
                  },
                ),
              ),
            ),
            // 1. Horizontal Categories
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Text(
                  "Categories",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: CategoryHorizontalList(
                gridColor: Constant.boxColor,
                items: categoryController.category,
                products: productController.products,
              ),
            ),

            // SliverToBoxAdapter(
            //   child: SizedBox(
            //     height: 130,
            //     child: ListView.separated(
            //       scrollDirection: Axis.horizontal,
            //       itemCount: categoryItemDemo.length,
            //       separatorBuilder: (_, __) => const SizedBox(width: 15),
            //       itemBuilder: (context, index) {
            //         return GestureDetector(
            //           onTap: () {
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                 builder: (context) =>
            //                     CategoryItemPage(categoryName: categoryItemDemo[index].name),
            //               ),
            //             );
            //           },
            //           child: Column(
            //             children: [
            //               Container(
            //                 height: 90,
            //                 width: 90,
            //                 padding: const EdgeInsets.all(15),
            //                 decoration: BoxDecoration(
            //                   color: gridColor[index % gridColor.length].withValues(alpha: 0.2),
            //                   borderRadius: BorderRadius.circular(12),
            //                   border: Border.all(
            //                     color: gridColor[index % gridColor.length].withValues(alpha: 0.3),
            //                     width: 1,
            //                   ),
            //                 ),
            //                 child: Image.asset(categoryItemDemo[index].imgPath),
            //               ),
            //               const SizedBox(height: 5),
            //               Text(
            //                 categoryItemDemo[index].name,
            //                 style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            //               ),
            //             ],
            //           ),
            //         );
            //       },
            //     ),
            //   ),
            // ),

            // 2. Vertical List (Image Left, Text Right)
            // 2. Vertical List (Styled like Daily Essentials)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "Popular Brands", // Updated Title to match pic
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Obx(() {
              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = brandController.brand[index];

                  return BrandItemCard(
                    bgColor: Constant.boxColor[index % Constant.boxColor.length],
                    item: item,
                  );
                }, childCount: brandController.brand.length),
              );
            }),
            SliverToBoxAdapter(child: SizedBox(height: 90)),

            // SliverList(
            //   delegate: SliverChildBuilderDelegate((context, index) {
            //     return Container(
            //       margin: const EdgeInsets.only(bottom: 20), // Spacing between items
            //       child: Row(
            //         crossAxisAlignment: CrossAxisAlignment.start, // Align to top
            //         children: [
            //           // --- LEFT SIDE: Image + Favorite Icon ---
            //           Stack(
            //             children: [
            //               Container(
            //                 height: 100,
            //                 width: 100,
            //                 decoration: BoxDecoration(
            //                   // Use a dynamic color bg or just grey/white
            //                   color: gridColor[index % gridColor.length].withValues(alpha: 0.1),
            //                   borderRadius: BorderRadius.circular(16),
            //                 ),
            //                 child: ClipRRect(
            //                   borderRadius: BorderRadius.circular(16),
            //                   child: Padding(
            //                     padding: const EdgeInsets.all(8.0),
            //                     child: Image.asset(
            //                       "assets/images/appBar/Local_brand/coca_cola.png",
            //                       fit: BoxFit.cover,
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //               // Heart Icon Top Right
            //               Positioned(
            //                 top: 5,
            //                 right: 5,
            //                 child: Container(
            //                   padding: const EdgeInsets.all(4),
            //                   decoration: const BoxDecoration(
            //                     color: Colors.white,
            //                     shape: BoxShape.circle,
            //                   ),
            //                   child: const Icon(
            //                     Icons.favorite_border,
            //                     size: 14,
            //                     color: Colors.grey,
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),

            //           const SizedBox(width: 15),

            //           // --- RIGHT SIDE: Info Column ---
            //           Expanded(
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 // 1. Shop Name
            //                 const Text(
            //                   "Coca Cola Company", // Placeholder Name
            //                   maxLines: 1,
            //                   overflow: TextOverflow.ellipsis,
            //                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            //                 ),
            //                 const SizedBox(height: 4),

            //                 // 2. Delivery Time
            //                 const Text(
            //                   "25-50 min",
            //                   style: TextStyle(color: Colors.grey, fontSize: 13),
            //                 ),
            //                 const SizedBox(height: 6),

            //                 // 3. Delivery Fee (Icon + Grey Text + Pink Text)
            //                 Row(
            //                   children: [
            //                     const Icon(Icons.delivery_dining, size: 16, color: Colors.grey),
            //                     const SizedBox(width: 4),
            //                     RichText(
            //                       text: const TextSpan(
            //                         style: TextStyle(fontSize: 12, color: Colors.grey),
            //                         children: [
            //                           TextSpan(text: "\$2.65"),
            //                           TextSpan(text: " or "),
            //                           TextSpan(
            //                             text: "Free with \$20 spend",
            //                             style: TextStyle(
            //                               // Using the pink color from your grid list
            //                               color: Color(0xffD73B77),
            //                               fontWeight: FontWeight.bold,
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //                 const SizedBox(height: 8),

            //                 // 4. Voucher Tag
            //                 Container(
            //                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            //                   decoration: BoxDecoration(
            //                     // Light pink background
            //                     color: const Color(0xffD73B77).withValues(alpha: 0.1),
            //                     borderRadius: BorderRadius.circular(5),
            //                   ),
            //                   child: Row(
            //                     mainAxisSize: MainAxisSize.min,
            //                     children: const [
            //                       Icon(
            //                         Icons.confirmation_num_outlined,
            //                         size: 14,
            //                         color: Color(0xffD73B77),
            //                       ),
            //                       SizedBox(width: 4),
            //                       Text(
            //                         "\$3 off \$25",
            //                         style: TextStyle(
            //                           color: Color(0xffD73B77),
            //                           fontSize: 12,
            //                           fontWeight: FontWeight.bold,
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //     );
            //   }, childCount: 10),
            // ),
          ],
        ),
      ),
    );
  }
}
