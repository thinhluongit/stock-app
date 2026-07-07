import 'package:flutter/material.dart';

/// Central color palette. Primary of the whole project is Green.
class AppColors {
  AppColors._();

  // Brand / primary (Green)
  static const Color primary = Color(0xFF00A651);
  static const Color primaryDark = Color(0xFF00783B);
  static const Color primaryLight = Color(0xFFE6F6EC);
  static const Color primaryBright = Color.fromARGB(255, 86, 206, 132);


  // Stock board semantic colors (theo bảng giá chứng khoán VN)
  static const Color up = Color(0xFF00A651); // giá tăng - xanh
  static const Color down = Color(0xFFE53935); // giá giảm - đỏ
  static const Color reference = Color(0xFFF2A900); // tham chiếu - vàng
  static const Color ceiling = Color(0xFFB03BE0); // trần - tím
  static const Color floor = Color(0xFF00B7C2); // sàn - xanh dương

  // Neutrals
  static const Color background = Color(0xFFF4F6F8);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF1B1B1B);
  static const Color textSecondary = Color(0xFF7C838A);
  static const Color divider = Color(0xFFE7EAEE);
}
