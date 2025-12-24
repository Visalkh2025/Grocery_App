import 'package:flutter/material.dart';
import 'package:grocery_app/constants/constant.dart';

class ReviewTile extends StatelessWidget {
  final double rating;
  final int totalReviews;

  const ReviewTile({super.key, required this.rating, this.totalReviews = 0});

  @override
  Widget build(BuildContext context) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    return ListTile(
      title: const Text(
        "Reviews",
        style: TextStyle(
          // fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      subtitle: Row(
        children: [
          // ⭐ Draw stars
          ...List.generate(
            fullStars,
            (index) => Icon(Icons.star_rounded, color: Colors.amber, size: 22),
          ),
          if (hasHalfStar) const Icon(Icons.star_half_rounded, color: Colors.amber, size: 22),
          ...List.generate(
            5 - fullStars - (hasHalfStar ? 1 : 0),
            (index) => Icon(Icons.star_border_rounded, color: Colors.amber, size: 22),
          ),

          const SizedBox(width: 8),

          Text(
            "$rating ($totalReviews reviews)",
            style: TextStyle(fontSize: 14, color: Constant.subTitle),
          ),
        ],
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 18,
        // color: Colors.grey,
      ),
    );
  }
}
