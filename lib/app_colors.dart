import 'package:flutter/material.dart';

class AppColors {
  static final MaterialColor primary = MaterialColor(0xFF288C38, primaryShades);
  static final MaterialColor secondary = MaterialColor(0xFFFBC800, secondaryShades);
  static const Color tertiary = Color(0xFF4B4B4B);
  static const Color textPrimary = Color(0xFF4B4B4B);
}

Map<int, Color> primaryShades = {
  100: Color(0xFFE7F2E9),
  200: Color(0xFFD0E6D3),
  300: Color(0xFFB8D9BD),
  400: Color(0xFFA0CCA7),
  500: Color(0xFF89C092),
  600: Color(0xFF71B37c),
  700: Color(0xFF59A666),
  800: Color(0xFF429A50),
  900: Color(0xFF288C38),
};

Map<int, Color> secondaryShades = {
  100: Color(0xFFFFF9E3),
  200: Color(0xFFFEF3C7),
  300: Color(0xFFFEEDAB),
  400: Color(0xFFFDE78F),
  500: Color(0xFFFDE173),
  600: Color(0xFFFCDB57),
  700: Color(0xFFFCD53B),
  800: Color(0xFFFBCF1F),
  900: Color(0xFFFBC800),
};