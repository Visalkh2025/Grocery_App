import 'package:flutter/material.dart';
import 'package:grocery_app/constants/constant.dart';

class CustomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;

  const CustomButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.backgroundColor,
    this.iconColor,
    this.size = 35,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ?? Constant.primaryColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (backgroundColor ?? Constant.primaryColor).withValues(alpha: .3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor ?? Colors.white, size: size * 0.5),
      ),
    );
  }
}
