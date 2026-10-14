import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Deep bottle green: calm, premium, reads well for apparel.
  static const Color _seed = Color(0xFF1E4D3B);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: _seed),
      );
}
