import 'package:flutter/material.dart';
import 'package:grocery_app/constants/constant.dart';

// class ReviewTile extends StatelessWidget {
//   final int rating;
//   final int totalReviews;

//   const ReviewTile({super.key, required this.rating, this.totalReviews = 0});

//   @override
//   Widget build(BuildContext context) {
//     int fullStars = rating.floor();
//     bool hasHalfStar = (rating - fullStars) >= 0.5;

//     return ListTile(
//       title: const Text(
//         "Reviews",
//         style: TextStyle(
//           // fontWeight: FontWeight.w600,
//           fontSize: 18,
//         ),
//       ),
//       subtitle: Row(
//         children: [
//           // ⭐ Draw stars
//           ...List.generate(
//             fullStars,
//             (index) => Icon(Icons.star_rounded, color: Colors.amber, size: 22),
//           ),
//           if (hasHalfStar) const Icon(Icons.star_half_rounded, color: Colors.amber, size: 22),
//           ...List.generate(
//             5 - fullStars - (hasHalfStar ? 1 : 0),
//             (index) => Icon(Icons.star_border_rounded, color: Colors.amber, size: 22),
//           ),

//           const SizedBox(width: 8),

//           Text(
//             "$rating ($totalReviews reviews)",
//             style: TextStyle(fontSize: 14, color: Constant.subTitle),
//           ),
//         ],
//       ),
//       trailing: const Icon(
//         Icons.arrow_forward_ios_rounded,
//         size: 18,
//         // color: Colors.grey,
//       ),
//     );
//   }
// }

class ReviewTile extends StatelessWidget {
  final int rating;
  final String userName;
  final String comment;
  final String? date;

  const ReviewTile({
    super.key,
    required this.rating,
    required this.userName,
    required this.comment,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey.shade300,
                child: Text(
                  userName[0].toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            userName,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < rating ? Icons.star : Icons.star_border,
                              size: 14,
                              color: Colors.amber,
                            );
                          }),
                        ),
                      ],
                    ),

                    SizedBox(height: 4),

                    Text(
                      comment,
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade800, height: 1.4),
                    ),

                    if (date != null) ...[
                      SizedBox(height: 6),
                      Text(date!, style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),

        Divider(height: 1, color: Colors.grey.shade300),
      ],
    );
  }
}
