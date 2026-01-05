import 'package:get/get.dart';
import 'package:grocery_app/controller/category_controller.dart';
import 'package:grocery_app/controller/product_controller.dart';
import 'package:grocery_app/widget/cart_item_widget.dart';
import 'package:grocery_app/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:grocery_app/widget/category_horizontal_list.dart';
import 'package:grocery_app/widget/loading-widget/loading_card_widget.dart';
import 'package:grocery_app/widget/product_section_home.dart';
import 'package:grocery_app/widget/text_anitmated.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final ProductController productController = Get.put(ProductController());
  final CategoryController cateController = Get.put(CategoryController());

  static const double maxHeaderHeight = 300;
  static const double minHeaderHeight = 110;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double offset = _scrollController.hasClients ? _scrollController.offset : 0;
    final double headerHeight = (maxHeaderHeight - offset).clamp(minHeaderHeight, maxHeaderHeight);
    final double collapseProgress =
        ((maxHeaderHeight - headerHeight) / (maxHeaderHeight - minHeaderHeight)).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Color.lerp(Constant.lightGreen, Constant.primaryColor, collapseProgress),
      body: Column(
        children: [
          // 1. Collapsing Header (Manual implementation)
          Container(
            height: headerHeight,
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              color: Color.lerp(Constant.lightGreen, Constant.primaryColor, collapseProgress),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Location Row
                if (headerHeight > 180)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Opacity(
                      opacity: (1 - collapseProgress * 1.2).clamp(0.0, 1.0),
                      child: Transform.translate(
                        offset: Offset(0, -20 * collapseProgress),
                        child: const _LocationRow(),
                      ),
                    ),
                  ),

                // Banner
                if (headerHeight > 200)
                  Positioned(
                    top: ((headerHeight / 2) - 30),
                    left: 0,
                    right: 0,
                    child: Opacity(
                      opacity: 1 - collapseProgress,
                      child: Transform.scale(
                        scale: 1 - (collapseProgress * 0.15),
                        child: const _Banner(),
                      ),
                    ),
                  ),

                // Search bar
                Positioned(
                  top: (headerHeight / 2) - 24 - 30 - (34 * (1 - collapseProgress)),
                  left: 0,
                  right: 0,
                  child: Transform.translate(
                    offset: Offset(0, -10 * collapseProgress),
                    child: const _SearchBar(),
                  ),
                ),
              ],
            ),
          ),

          // 2. Main Content (Expanded ListView)
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: ListView(
                controller: _scrollController,
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox(height: 16),
                  _bannerCarousel(),
                  const SizedBox(height: 15),

                  _sectionHeader("Categories"),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: CategoryHorizontalList(
                      gridColor: Constant.boxColor,
                      items: cateController.category,
                      products: productController.products,
                    ),
                  ),
                  Obx(() {
                    if (productController.isProductsLoading.isTrue) {
                      return const LoadingCardWidget();
                    }
                    return ProductSectionHome(title: "New Arrival", sort: 'newest');
                  }),
                  Obx(() {
                    if (productController.isProductsLoading.isTrue) {
                      return const LoadingCardWidget();
                    }
                    return ProductSectionHome(title: 'Best Selling', sort: 'best_selling');
                  }),
                  const SizedBox(height: 30),
                  TextAnimated(cateController.category.map((e) => e.name).toList()),
                  Obx(() {
                    if (productController.isProductsLoading.isTrue) {
                      return const LoadingCardWidget();
                    }
                    return _horizontalItemList();
                  }),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bannerCarousel() {
    return SizedBox(
      height: 190,
      child: CarouselSlider(
        items: Constant.bannerImages.map((imagePath) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                imagePath,
                fit: BoxFit.fill,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          );
        }).toList(),
        options: CarouselOptions(
          height: 200,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.9,
        ),
      ),
    );
  }

  // Widget _categories() {
  //   final cateItem = cateController.category;
  //   return Column(
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             const Text('Categories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
  //             Text(
  //               "See all",
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 color: Constant.primaryColor,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       SizedBox(
  //         height: 130,
  //         child: ListView.separated(
  //           scrollDirection: Axis.horizontal,
  //           itemCount: cateItem.length,
  //           padding: const EdgeInsets.symmetric(horizontal: 20),
  //           separatorBuilder: (_, __) => const SizedBox(width: 15),
  //           itemBuilder: (context, index) {
  //             return GestureDetector(
  //               onTap: () {
  //                 // Navigator.push(
  //                 //   context,
  //                 //   MaterialPageRoute(
  //                 //     builder: (context) => CategoryItemPage(category: cateItem[index]),
  //                 //   ),
  //                 // );
  //                 Get.to(
  //                   () => CategoryItemPage(category: cateItem[index]),
  //                   transition: Transition.rightToLeft,
  //                 );
  //               },
  //               child: Column(
  //                 children: [
  //                   Container(
  //                     height: 90,
  //                     width: 90,
  //                     padding: const EdgeInsets.all(15),
  //                     decoration: BoxDecoration(
  //                       color: Constant.boxColor[index % Constant.boxColor.length].withOpacity(0.2),
  //                       borderRadius: BorderRadius.circular(12),
  //                       border: Border.all(
  //                         color: Constant.boxColor[index % Constant.boxColor.length].withOpacity(
  //                           0.3,
  //                         ),
  //                         width: 1,
  //                       ),
  //                     ),
  //                     child: Image.network(cateItem[index].image),
  //                   ),
  //                   const SizedBox(height: 5),
  //                   Text(
  //                     cateItem[index].name,
  //                     style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _sectionHeader(String title) {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
  //         Text(
  //           "See all",
  //           style: TextStyle(
  //             fontSize: 16,
  //             color: Constant.primaryColor,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _sectionHeader(String title) {
    return Padding(
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

          // "See all" with arrow
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
    );
  }

  Widget _horizontalItemList() {
    final items = productController.products;
    return SizedBox(
      height: 260,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(width: 15),
        itemBuilder: (context, index) {
          return SizedBox(width: 170, child: CartItemWidget(product: items[index]));
        },
      ),
    );
  }
}

/// app bar components
class _LocationRow extends StatelessWidget {
  const _LocationRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.location_on, size: 28, color: Colors.white),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Current Location", style: TextStyle(fontSize: 13, color: Colors.white)),
              Text(
                "Phnom Penh, Cambodia",
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Icon(Icons.favorite_border, color: Colors.white, size: 28),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: const [
          Icon(Icons.search, color: Colors.grey),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Search for restaurants, cuisines or dishes",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner();

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 20),
      //decoration: BoxDecoration(
      // color: Constant.primaryColor,
      // borderRadius: BorderRadius.circular(18),
      // boxShadow: [
      //   BoxShadow(
      //     color: Constant.primaryColor.withOpacity(0.4),
      //     blurRadius: 10,
      //     offset: const Offset(0, 5),
      //   ),
      // ],
      //),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          spacing: 25,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Enjoy up 70% off & free delivery !",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),

                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 8,
                  //     vertical: 4,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white.withOpacity(0.2),
                  //     borderRadius: BorderRadius.circular(4),
                  //   ),
                  //   child: const Text(
                  //     "On your first order",
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 12,
                  //       fontWeight: FontWeight.w500,
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 15),
                  Row(
                    children: const [
                      Text(
                        "Start ordering",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.arrow_circle_right_outlined, color: Colors.white, size: 18),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 85,
                    width: 85,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        "assets/images/appBar/Local_brand/khmer_beverages.png",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,

                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.error, color: Colors.red);
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "-10%",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
