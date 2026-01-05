import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/constants/constant.dart';

Widget TextAnimated(List<String>? titles) {
  if (titles == null || titles.isEmpty) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),
          Text(
            "See all",
            style: TextStyle(
              fontSize: 16,
              color: Constant.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Animated title
        // AnimatedTextKit(
        //   repeatForever: true,
        //   animatedTexts: titles.map((t) {
        //     return TyperAnimatedText(
        //       t,
        //       textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        //       speed: const Duration(milliseconds: 150),
        //     );
        //   }).toList(),
        // ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start, // align left
          children: [
            SizedBox(
              width: 200, // fixed width to match max text length
              child: AnimatedTextKit(
                repeatForever: true,
                animatedTexts: titles.map((t) {
                  return TyperAnimatedText(
                    t,
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    speed: const Duration(milliseconds: 150),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              height: 3,
              width: 40, // fixed underline width
              decoration: BoxDecoration(
                color: Constant.primaryColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),

        // See all button
        GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              Text(
                "See all",
                style: TextStyle(
                  fontSize: 16,
                  color: Constant.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 5),
              Icon(Icons.arrow_forward_ios, size: 16, color: Constant.primaryColor),
            ],
          ),
        ),
      ],
    ),
  );
}
