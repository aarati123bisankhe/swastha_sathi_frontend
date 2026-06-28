import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  const backgroundColor = Color(0xFFD9EAF6);

  return ThemeData(
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF1E63B6),
      surface: backgroundColor,
    ),
    useMaterial3: true,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: Color(0xFF1E63B6),
        letterSpacing: 0.2,
      ),
      bodyMedium: TextStyle(fontSize: 16, color: Color(0xFF315067)),
    ),
  );
}
