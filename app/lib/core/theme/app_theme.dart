import 'package:flutter/material.dart';

/// Tema TuturTangan.
///
/// Pengguna utama mengandalkan kanal visual, sehingga tema menekankan
/// kontras tinggi, teks besar, dan target sentuh lebar
/// (NFR-003 Usability, NFR-007 Accessibility).
class AppTheme {
  const AppTheme._();

  static const Color _seed = Color(0xFF1B5E9B);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFF7F9FC),
      visualDensity: VisualDensity.comfortable,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 18, height: 1.5),
        bodyMedium: TextStyle(fontSize: 16, height: 1.5),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
