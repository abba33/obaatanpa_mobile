import 'package:flutter/material.dart';

/// App Colors - Exact replica of web app color scheme
/// Based on Tailwind config: primary (#F59297/#e67d82) and secondary (#7da8e6)
class AppColors {
  // Primary Colors (Pink) - Exact match from web app
  static const Color primary50 = Color(0xFFFEF7F7);
  static const Color primary100 = Color(0xFFFDEAEA);
  static const Color primary200 = Color(0xFFFBD9DB);
  static const Color primary300 = Color(0xFFF7BCC0);
  static const Color primary400 = Color(0xFFF1939A);
  static const Color primary500 = Color(0xFFE67D82); // Main primary from web
  static const Color primary600 = Color(0xFFD46A6F);
  static const Color primary700 = Color(0xFFB85459);
  static const Color primary800 = Color(0xFF9A474C);
  static const Color primary900 = Color(0xFF823F44);

  // Web app uses #F59297 in many places, so we include it
  static const Color primaryWeb = Color(0xFFF59297);

  // Secondary Colors (Blue) - Exact match from web app
  static const Color secondary50 = Color(0xFFF0F9FF);
  static const Color secondary100 = Color(0xFFE0F2FE);
  static const Color secondary200 = Color(0xFFBAE6FD);
  static const Color secondary300 = Color(0xFF7DD3FC);
  static const Color secondary400 = Color(0xFF38BDF8);
  static const Color secondary500 = Color(0xFF0EA5E9);
  static const Color secondary600 = Color(0xFF0284C7);
  static const Color secondary700 = Color(0xFF0369A1);
  static const Color secondary800 = Color(0xFF075985);
  static const Color secondary900 = Color(0xFF0C4A6E);

  // Web app uses #7da8e6 in many places, so we include it
  static const Color secondaryWeb = Color(0xFF7DA8E6);

  // Gradient Colors (matching web app gradients)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryWeb, secondaryWeb],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [
      Color(0xFFFDF2F8), // pink-50
      Color(0xFFF0F9FF), // blue-50
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Dark Mode Colors
  static const Color darkBackground = Color(0xFF111827);
  static const Color darkSurface = Color(0xFF1F2937);
  static const Color darkCard = Color(0xFF374151);

  // Opacity variations (matching web app usage)
  static Color primaryWithOpacity(double opacity) => primaryWeb.withOpacity(opacity);
  static Color secondaryWithOpacity(double opacity) => secondaryWeb.withOpacity(opacity);
  static Color whiteWithOpacity(double opacity) => white.withOpacity(opacity);
  static Color blackWithOpacity(double opacity) => black.withOpacity(opacity);

  // Background gradients used in web app
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFDF2F8), // pink-50
      Color(0xFFFEF7F7), // pink-50 variant
      Color(0xFFF0F9FF), // blue-50
    ],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFFEFEFE),
    ],
  );

  // Floating elements colors (from hero section)
  static Color floatingPink = primaryWeb.withOpacity(0.3);
  static Color floatingBlue = secondaryWeb.withOpacity(0.3);
}

/// Color extensions for easy usage
extension AppColorsExtension on Color {
  /// Creates a material color swatch from a single color
  MaterialColor toMaterialColor() {
    final Map<int, Color> swatch = {
      50: withOpacity(0.1),
      100: withOpacity(0.2),
      200: withOpacity(0.3),
      300: withOpacity(0.4),
      400: withOpacity(0.5),
      500: this,
      600: withOpacity(0.7),
      700: withOpacity(0.8),
      800: withOpacity(0.9),
      900: withOpacity(1.0),
    };
    return MaterialColor(value, swatch);
  }
}
