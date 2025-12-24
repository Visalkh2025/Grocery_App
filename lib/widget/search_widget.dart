import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_app/constants/constant.dart';

class SearchWidget extends StatefulWidget {
  final void Function()? onTap;
  const SearchWidget({super.key, this.onTap});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F3F2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              Constant.searchIcon,
              width: 22,
              height: 22,
              color: Colors.black.withAlpha(180),
            ),
            const SizedBox(width: 15),
            const Expanded(
              child: Text(
                "Search for groceries",
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF7C7C7C),
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
