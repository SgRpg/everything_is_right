import 'package:flutter/material.dart';

class AppColors {
  static const cream = Color(0xFFFFF7EA);
  static const warmCream = Color(0xFFFFFBF3);
  static const apricot = Color(0xFFFFD59B);
  static const peach = Color(0xFFFFB08A);
  static const orange = Color(0xFFFF7A2F);
  static const brown = Color(0xFF4B2517);
  static const softBrown = Color(0xFF8A5F4B);
  static const border = Color(0xFFF4D7BD);
}

final List<BoxShadow> softShadow = [
  BoxShadow(
    color: AppColors.orange.withValues(alpha: 0.12),
    blurRadius: 18,
    offset: const Offset(0, 8),
  ),
];
