import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Lightweight number formatters so the app has zero external deps (offline).

String _groupThousands(String digits) {
  final buffer = StringBuffer();
  final len = digits.length;
  for (var i = 0; i < len; i++) {
    if (i > 0 && (len - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

/// 12345.6 -> "12,345.60"
String formatPrice(num value, {int decimals = 2}) {
  final negative = value < 0;
  final fixed = value.abs().toStringAsFixed(decimals);
  final parts = fixed.split('.');
  final intPart = _groupThousands(parts[0]);
  final out = parts.length > 1 ? '$intPart.${parts[1]}' : intPart;
  return negative ? '-$out' : out;
}

/// 1234567 -> "1.23M", 12345 -> "12,345"
String formatVolume(num value) {
  if (value >= 1000000000) {
    return '${(value / 1000000000).toStringAsFixed(2)}B';
  }
  if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(2)}M';
  return _groupThousands(value.round().toString());
}

/// +1.25 / -0.80 (with explicit sign)
String formatChange(num value, {int decimals = 2}) {
  final sign = value > 0 ? '+' : (value < 0 ? '' : '');
  return '$sign${formatPrice(value, decimals: decimals)}';
}

/// +1.25% / -0.80%
String formatPercent(num value, {int decimals = 2}) {
  final sign = value > 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(decimals)}%';
}

/// Color used to render a change value on the board.
Color changeColor(num change) {
  if (change > 0) return AppColors.up;
  if (change < 0) return AppColors.down;
  return AppColors.reference;
}
