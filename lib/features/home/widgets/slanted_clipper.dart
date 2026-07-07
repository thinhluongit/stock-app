import 'package:flutter/material.dart';

class SlantedClipper extends CustomClipper<Path> {
  final bool isLeft;

  SlantedClipper({required this.isLeft});

  @override
  Path getClip(Size size) {
    const double cut = 20;

    final path = Path();

    if (isLeft) {
      // Nút bên trái
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width - cut, size.height);
      path.lineTo(0, size.height);
    } else {
      // Nút bên phải
      path.moveTo(cut, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}