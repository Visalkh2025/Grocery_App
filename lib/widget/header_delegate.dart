import 'dart:ui';

import 'package:flutter/material.dart';

class HeaderDelegate extends SliverPersistentHeaderDelegate {
  final double safeAreaPadding;
  final Color primaryColor;

  HeaderDelegate({required this.safeAreaPadding, required this.primaryColor});

  @override
  double get minExtent => safeAreaPadding + 62;

  @override
  double get maxExtent => minExtent + 55;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = shrinkOffset / (maxExtent - minExtent);
    final opacity = (1 - (progress * 1.5)).clamp(0.0, 1.0);

    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: safeAreaPadding + 5,
            left: 20,
            right: 20,
            child: Opacity(
              opacity: opacity,
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white, size: 24),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Selected location",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const Text(
                        "Phnom Penh",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 15,
            left: 20,
            right: 20,
            child: SizedBox(
              height: 45,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 15),
                    Icon(Icons.search, color: Colors.grey.shade600, size: 24),
                    const SizedBox(width: 10),
                    Text(
                      "Search for groceries",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant HeaderDelegate oldDelegate) {
    return oldDelegate.safeAreaPadding != safeAreaPadding ||
        oldDelegate.primaryColor != primaryColor;
  }
}
