// class FoodpandaHome extends StatefulWidget {
//   const FoodpandaHome({super.key});

//   @override
//   State<FoodpandaHome> createState() => _FoodpandaHomeState();
// }

// class _FoodpandaHomeState extends State<FoodpandaHome> {
//   final ScrollController _scrollController = ScrollController();

//   static const double maxHeaderHeight = 300;
//   static const double minHeaderHeight = 120;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(() {
//       setState(() {}); // rebuild on scroll
//     });
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double offset = _scrollController.hasClients ? _scrollController.offset : 0;
//     final double headerHeight = (maxHeaderHeight - offset).clamp(minHeaderHeight, maxHeaderHeight);
//     final double collapseProgress =
//         ((maxHeaderHeight - headerHeight) / (maxHeaderHeight - minHeaderHeight)).clamp(0.0, 1.0);
//     return Scaffold(
//       backgroundColor: Color.lerp(Colors.pink.shade100, Colors.pink.shade500, collapseProgress),
//       body: Column(
//         children: [
//           // 🔥 Collapsing header
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 0),
//             height: headerHeight,
//             width: double.infinity,
//             padding: EdgeInsets.only(
//               top: MediaQuery.of(context).padding.top + 10,
//               left: 16,
//               right: 16,
//             ),
//             decoration: BoxDecoration(
//               color: Color.lerp(Colors.pink.shade100, const Color(0xFFE91E63), collapseProgress),
//             ),
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: [
//                 // Location Row
//                 if (headerHeight > 180)
//                   // Positioned(
//                   //   top: 0,
//                   //   left: 0,
//                   //   right: 0,
//                   //   child: Opacity(
//                   //     opacity: 1 - collapseProgress,
//                   //     child: Transform.translate(
//                   //       offset: Offset(0, -20 * collapseProgress),
//                   //       child: const _LocationRow(),
//                   //     ),
//                   //   ),
//                   // ),
//                   // Location Row (fade smoothly)
//                   Positioned(
//                     top: 0,
//                     left: 0,
//                     right: 0,
//                     child: Opacity(
//                       opacity: (1 - collapseProgress * 1.2).clamp(
//                         0.0,
//                         1.0,
//                       ), // adjust multiplier to control when it fades
//                       child: Transform.translate(
//                         offset: Offset(0, -20 * collapseProgress),
//                         child: const _LocationRow(),
//                       ),
//                     ),
//                   ),

//                 // Banner above search bar
//                 if (headerHeight > 200)
//                   Positioned(
//                     // top: 170,
//                     // top: (headerHeight - 120),
//                     top: ((headerHeight / 2) - 30),

//                     left: 0,
//                     right: 0,
//                     child: Opacity(
//                       opacity: 1 - collapseProgress,
//                       child: Transform.scale(
//                         scale: 1 - (collapseProgress * 0.15),
//                         child: const _Banner(),
//                       ),
//                     ),
//                   ),

//                 // Search bar in middle
//                 Positioned(
//                   // top: (headerHeight / 2) - 24 - 30, // 24 = half of search bar height
//                   // top: (headerHeight / 2) - 24 - 30 - 34, // 24 = half of search bar height
//                   top:
//                       (headerHeight / 2) -
//                       24 -
//                       30 -
//                       (34 * (1 - collapseProgress)), // dynamically remove -34 as it collapses
//                   left: 0,
//                   right: 0,
//                   child: Transform.translate(
//                     offset: Offset(0, -10 * collapseProgress),
//                     child: const _SearchBar(),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // 📦 Main content
//           Expanded(
//             child: Container(
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(24),
//                   topRight: Radius.circular(24),
//                 ),
//               ),
//               child: ListView.builder(
//                 controller: _scrollController,
//                 padding: const EdgeInsets.only(top: 16),
//                 itemCount: 50,
//                 itemBuilder: (context, index) {
//                   return Container(
//                     height: 50,
//                     margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade200,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     alignment: Alignment.center,
//                     child: Text("Item $index", style: const TextStyle(fontSize: 16)),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// 📍 Location Row
// class _LocationRow extends StatelessWidget {
//   const _LocationRow();

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: const [
//         Icon(Icons.location_on, size: 28),
//         SizedBox(width: 8),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("Current Location", style: TextStyle(fontSize: 13, color: Colors.black54)),
//               Text(
//                 "Phnom Penh, Cambodia",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ),
//         Icon(Icons.favorite_border, size: 28),
//       ],
//     );
//   }
// }

// /// 🔍 Search Bar
// class _SearchBar extends StatelessWidget {
//   const _SearchBar();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 45,
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: const [
//           Icon(Icons.search, color: Colors.grey),
//           SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               "Search for restaurants, cuisines or dishes",
//               style: TextStyle(color: Colors.grey),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// 🎉 Promo Banner
// class _Banner extends StatelessWidget {
//   const _Banner();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 100,
//       decoration: BoxDecoration(color: Colors.pink, borderRadius: BorderRadius.circular(16)),
//       alignment: Alignment.center,
//       child: const Text(
//         "Enjoy up to 60% off\non your first order!",
//         textAlign: TextAlign.center,
//         style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: FoodpandaHome());
  }
}

class FoodpandaHome extends StatelessWidget {
  const FoodpandaHome({super.key});

  static const double maxHeaderHeight = 300;
  static const double minHeaderHeight = 120;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade100,
      body: CustomScrollView(
        slivers: [
          /// 🔥 COLLAPSING HEADER (EXACT SAME LOGIC AS OLD VERSION)
          SliverPersistentHeader(
            pinned: true,
            delegate: _FoodpandaHeaderDelegate(
              maxHeight: maxHeaderHeight,
              minHeight: minHeaderHeight,
            ),
          ),

          /// 📦 CONTENT
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                children: List.generate(
                  50,
                  (index) => Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text("Item $index", style: const TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 🔥 HEADER DELEGATE (REPLACES ScrollController)
class _FoodpandaHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double maxHeight;
  final double minHeight;

  _FoodpandaHeaderDelegate({required this.maxHeight, required this.minHeight});

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double headerHeight = (maxHeight - shrinkOffset).clamp(minHeight, maxHeight);

    final double collapseProgress = ((maxHeight - headerHeight) / (maxHeight - minHeight)).clamp(
      0.0,
      1.0,
    );

    return Container(
      color: Color.lerp(Colors.pink.shade100, const Color(0xFFE91E63), collapseProgress),
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, left: 16, right: 16),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          /// 📍 LOCATION ROW
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

          /// 🎉 BANNER
          if (headerHeight > 200)
            Positioned(
              top: (headerHeight / 2) - 30,
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

          /// 🔍 SEARCH BAR (SAME MATH AS YOUR OLD CODE)
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
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

/// 📍 LOCATION ROW
class _LocationRow extends StatelessWidget {
  const _LocationRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Icon(Icons.location_on, size: 28),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Current Location", style: TextStyle(fontSize: 13, color: Colors.black54)),
              Text(
                "Phnom Penh, Cambodia",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Icon(Icons.favorite_border, size: 28),
      ],
    );
  }
}

/// 🔍 SEARCH BAR
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
            color: Colors.black.withOpacity(0.08),
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

/// 🎉 BANNER
class _Banner extends StatelessWidget {
  const _Banner();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(color: Colors.pink, borderRadius: BorderRadius.circular(16)),
      alignment: Alignment.center,
      child: const Text(
        "Enjoy up to 60% off\non your first order!",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
