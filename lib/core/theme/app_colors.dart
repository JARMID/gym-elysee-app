import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  // Primary Colors - FIERY THEME UPDATE
  static const Color primary = Color(
    0xFFFFC107,
  ); // Amber/Bright Yellow (Matches Brand)
  static const Color primaryDark = Color(0xFFF57C00); // Deep Orange
  static const Color primaryLight = Color(0xFFFFE082); // Light Amber

  // Premium Brand Theme (Landing) - Orange/Yellow per hero screenshot
  // Premium Brand Theme (Landing) - Fiery Amber/Orange
  static const Color brandOrange = Color(0xFFFF9800); // Orange
  static const Color brandYellow = Color(0xFFFFC107); // Amber/Bright Yellow
  static const Color gold = brandYellow; // Alias for backward compatibility
  static const Color goldHover = Color(0xFFFFB300); // Lighter Amber
  static const Color goldDark = Color(0xFFF57C00); // Darker Orange
  static const Color darkBackground = Color(0xFF0A0A0A); // Pure dark

  // Premium Blue Accent (Technology/App)
  static const Color premiumBlue = Color(0xFF2962FF); // Electric Royal Blue
  static const Color premiumBlueLight = Color(0xFF448AFF);
  static const Color premiumBlueDark = Color(0xFF0039CB);

  // ═══════════════════════════════════════════════════════════════════
  // WEB PREMIUM PALETTE - Modern professional colors
  // ═══════════════════════════════════════════════════════════════════

  // Primary Web Accent - Gold for premium consistency
  static const Color webPrimary = gold;
  static const Color webPrimaryLight = goldHover;
  static const Color webPrimaryDark = goldDark;

  // Secondary Web Accent - Dark Grey/Black
  static const Color webSecondary = Color(0xFF1E1E1E);
  static const Color webSecondaryLight = Color(0xFF2C2C2C);
  static const Color webSecondaryDark = Color(0xFF000000);

  // Tertiary Accent - White for contrast
  static const Color webAccent = Colors.white;
  static const Color webAccentLight = Colors.white70;
  static const Color webAccentDark = Colors.grey;

  // Neon Effects - Kept minimal or Gold-tinted
  static const Color neonCyan = gold; // Mapped to Gold
  static const Color neonPurple = goldDark; // Mapped to Gold Dark
  static const Color neonBlue = Colors.white; // Mapped to White
  static const Color neonGreen = Color(0xFF00E676); // Keep green for success

  // Web Gradients - Section backgrounds (Strictly Dark)
  static const Color webGradientStart = Color(0xFF0F0F0F);
  static const Color webGradientMid = Color(0xFF141414);
  static const Color webGradientEnd = Color(0xFF0A0A0F);

  // Glassmorphism
  static const Color glassWhite = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color glassBlur = Color(0x0DFFFFFF);

  // Card Variants - For visual hierarchy
  static const Color cardDark = Color(0xFF12121A);
  static const Color cardMedium = Color(0xFF1A1A24);
  static const Color cardLight = Color(0xFF22222E);
  static const Color cardHover = Color(0xFF2A2A38);

  // Status Colors - Web specific
  static const Color webSuccess = Color(0xFF00C853);
  static const Color webWarning = Color(0xFFFFAB00);
  static const Color webError = Color(0xFFFF5252);
  static const Color webInfo = Color(0xFF448AFF);

  // Secondary Colors
  static const Color secondary = Color(0xFF607D8B); // Blue Grey
  static const Color secondaryDark = Color(0xFF455A64);
  static const Color secondaryLight = Color(0xFF90A4AE);

  // Accent Colors
  static const Color accent = Color(0xFFFF9800); // Orange
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Background Colors (Dark Theme)
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color surfaceVariant = Color(0xFF2C2C2C);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textDisabled = Color(0xFF666666);

  // Ramadan Theme Colors
  static const Color ramadanGold = Color(0xFFD4AF37);
  static const Color ramadanPurple = Color(0xFF2D1B3D);
  static const Color ramadanDarkPurple = Color(0xFF1A0F2E);
  static const Color ramadanLightGold = Color(0xFFFFD700);

  // Status Colors
  static const Color active = success;
  static const Color inactive = Color(0xFF757575);
  static const Color pending = warning;
  static const Color suspended = error;

  // Card Colors
  static const Color cardBackground = surface;
  static const Color cardElevated = surfaceVariant;

  // Divider
  static const Color divider = Color(0xFF333333);

  // Overlay
  static const Color overlay = Color(0x80000000);

  // Fiery Gradient Helper
  static const List<Color> fieryGradientColors = [
    Color(0xFFFFC107), // Amber
    Color(0xFFFF9800), // Orange
    Color(0xFFFF5722), // Deep Orange
  ];

  static LinearGradient get fieryGradient => const LinearGradient(
    colors: fieryGradientColors,
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static Shader get fieryShader => const LinearGradient(
    colors: fieryGradientColors,
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ).createShader(const Rect.fromLTWH(0, 0, 200, 70));
}
