import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary
  static const primary = Color(0xFF003F87);
  static const primaryContainer = Color(0xFF0056B3);
  static const onPrimary = Colors.white;
  static const onPrimaryContainer = Color(0xFFBBD0FF);
  static const primaryFixed = Color(0xFFD7E2FF);

  // Secondary (green)
  static const secondary = Color(0xFF006E25);
  static const secondaryContainer = Color(0xFF80F98B);
  static const onSecondary = Colors.white;
  static const onSecondaryContainer = Color(0xFF007327);

  // Tertiary
  static const tertiary = Color(0xFF003D91);
  static const tertiaryFixed = Color(0xFFD9E2FF);

  // Surface
  static const surface = Color(0xFFF8F9FA);
  static const surfaceWhite = Colors.white;
  static const surfaceContainer = Color(0xFFEDEEEF);
  static const surfaceContainerLow = Color(0xFFF3F4F5);
  static const surfaceContainerHigh = Color(0xFFE7E8E9);
  static const surfaceContainerHighest = Color(0xFFE1E3E4);

  // On Surface
  static const onSurface = Color(0xFF191C1D);
  static const onSurfaceVariant = Color(0xFF424752);
  static const outline = Color(0xFF727784);
  static const outlineVariant = Color(0xFFC2C6D4);

  // Text
  static const textPrimary = Color(0xFF001D41);
  static const textSecondary = Color(0xFF333333);

  // Error
  static const error = Color(0xFFBA1A1A);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onError = Colors.white;
  static const onErrorContainer = Color(0xFF93000A);
  static const errorRed = Color(0xFFDC3545);

  // Background
  static const background = Color(0xFFF8F9FA);
  static const onBackground = Color(0xFF191C1D);
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.tertiary,
        onTertiary: Colors.white,
        tertiaryContainer: AppColors.tertiaryFixed,
        onTertiaryContainer: AppColors.tertiary,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        surfaceContainerHighest: AppColors.surfaceContainerHighest,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
      ),
      textTheme: GoogleFonts.interTextTheme(),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceWhite,
        foregroundColor: AppColors.onSurface,
        elevation: 1,
        shadowColor: Colors.black12,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
