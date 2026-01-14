import 'package:flutter/material.dart';

class PinClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;

    Path path = Path();
    path.moveTo(w * 0.5, 0);
    path.cubicTo(w * 0.28, 0, w * 0.125, h * 0.1875, w * 0.125, h * 0.4125);
    path.cubicTo(w * 0.125, h * 0.65, w * 0.5, h, w * 0.5, h);
    path.cubicTo(w * 0.5, h, w * 0.875, h * 0.65, w * 0.875, h * 0.4125);
    path.cubicTo(w * 0.875, h * 0.1875, w * 0.72, 0, w * 0.5, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
