import 'package:flutter/material.dart';
import 'package:grocery_app/constants/constant.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? nextPage;
  final double fontSize;
  final Color? backgroundColor;
  final Color textColor;
  final double borderRadius;
  final bool isReplace;
  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.nextPage,
    this.fontSize = 17,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.borderRadius = 12,
    this.isReplace = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          // ! null assertion: tell dart that's not null
          if (onPressed != null) {
            onPressed!();
          } else if (nextPage != null) {
            if (isReplace) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => nextPage!),
              );
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (context) => nextPage!));
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Constant.primaryColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
        ),
        child: Text(text, style: TextStyle(fontSize: fontSize)),
      ),
    );
  }
}
