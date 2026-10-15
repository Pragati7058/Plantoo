import 'package:flutter/material.dart';

class AppColors {
  // Minimal Green Palette
  static const Color deepestBackground = Color(0xFF051F20);
  static const Color primaryBackground = Color(0xFF0B2B26);
  static const Color secondarySurface = Color(0xFF163832);
  static const Color elevatedSurface = Color(0xFF235347);
  static const Color accent = Color(0xFF8EB69B);
  static const Color lightText = Color(0xFFDAF1DE);
  
  // Enhanced glossy colors
  static const Color glossyHighlight = Color(0xFFFFFFFF);
  static const Color glossyReflection = Color(0x40FFFFFF);
  static const Color shimmerColor = Color(0x80FFFFFF);
  
  // Glass effect colors
  static Color glassOverlay({double opacity = 0.08}) =>
      Colors.white.withValues(alpha: opacity);
  static Color glassBorder({double opacity = 0.25}) =>
      accent.withValues(alpha: opacity);
  static Color glassHighlight({double opacity = 0.15}) =>
      glossyHighlight.withValues(alpha: opacity);
  
  // Gradient colors
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      deepestBackground,
      primaryBackground,
      secondarySurface,
    ],
    stops: [0.0, 0.5, 1.0],
  );
  
  static const LinearGradient primaryButtonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      accent,
      lightText,
    ],
  );
  
  static const LinearGradient glossyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x30FFFFFF),
      Color(0x10FFFFFF),
      Color(0x05FFFFFF),
    ],
    stops: [0.0, 0.5, 1.0],
  );
  
  static const LinearGradient activeNavGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      accent,
      Color(0xFFB8E6C9),
      lightText,
    ],
  );
  
  // Enhanced shadow colors with glossy effects
  static List<BoxShadow> get glassShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.15),
      offset: const Offset(0, 4),
      blurRadius: 20,
      spreadRadius: 0,
    ),
  ];
  
  static List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: accent.withValues(alpha: 0.3),
      offset: const Offset(0, 4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];
  
  static List<BoxShadow> get activeGlowShadow => [
    BoxShadow(
      color: accent.withValues(alpha: 0.5),
      offset: const Offset(0, 0),
      blurRadius: 20,
      spreadRadius: 2,
    ),
  ];
  
  static List<BoxShadow> get floatingShadow => [];
}
