import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

ThemeData buildAppTheme() {
  const scheme = ColorScheme.dark(
    primary: AppPalette.accent,
    secondary: AppPalette.accentSoft,
    surface: AppPalette.surface,
  );

  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppPalette.bg,
    colorScheme: scheme,
    useMaterial3: true,
    iconTheme: const IconThemeData(color: AppPalette.textPrimary),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: AppPalette.textPrimary,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: TextStyle(color: AppPalette.textPrimary),
      bodyMedium: TextStyle(color: AppPalette.textMuted),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppPalette.accent,
        foregroundColor: Colors.white,
        shape: const StadiumBorder(),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: BorderSide(color: Colors.white.withOpacity(0.2)),
        shape: const StadiumBorder(),
      ),
    ),
  );
}
