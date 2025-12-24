import 'package:flutter/material.dart';
import 'package:grocery_app/constants/constant.dart';

class CustomExpansionTile extends StatelessWidget {
  final String title;
  final String content;

  const CustomExpansionTile({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Constant.primaryColor),
        ),
        // trailing: const Icon(
        //   Icons.keyboard_arrow_down_rounded,
        //   color: Colors.grey,
        // ),
        children: [
          Text(content, style: TextStyle(fontSize: 15, color: Colors.grey.shade700, height: 1.5)),
        ],
      ),
    );
  }
}
