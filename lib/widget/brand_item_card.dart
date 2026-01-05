import 'package:flutter/material.dart';
import 'package:grocery_app/models/brand.dart';

class BrandItemCard extends StatelessWidget {
  final Color bgColor;
  final Brand item;

  const BrandItemCard({super.key, required this.bgColor, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: bgColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(item.image, fit: BoxFit.contain),
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.favorite_border, size: 14, color: Colors.grey),
                ),
              ),
            ],
          ),
          const SizedBox(width: 15),
          // --- RIGHT SIDE: Info Column ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Shop Name
                Text(
                  item.name, // Placeholder Name
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),

                // 2. Delivery Time
                const Text("25-50 min", style: TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 6),

                // 3. Delivery Fee (Icon + Grey Text + Pink Text)
                Row(
                  children: [
                    const Icon(Icons.delivery_dining, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        children: [
                          TextSpan(text: "\$2.65"),
                          TextSpan(text: " or "),
                          TextSpan(
                            text: "Free with \$20 spend",
                            style: TextStyle(color: Color(0xffD73B77), fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // 4. Voucher Tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xffD73B77).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.confirmation_num_outlined, size: 14, color: Color(0xffD73B77)),
                      SizedBox(width: 4),
                      Text(
                        "\$3 off \$25",
                        style: TextStyle(
                          color: Color(0xffD73B77),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
