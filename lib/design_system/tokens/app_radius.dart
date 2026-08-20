import 'package:flutter/material.dart';

/// Tokens Primitivos y Semánticos de Radios de Borde para SafeAccess 90.
abstract class AppRadius {
  // ==========================================
  // TOKENS PRIMITIVOS
  // ==========================================
  static const double radiusSmallValue = 4.0;
  static const double radiusMediumValue = 8.0;
  static const double radiusLargeValue = 16.0;

  // BorderRadius primitivos
  static final BorderRadius radiusSmall = BorderRadius.circular(radiusSmallValue);
  static final BorderRadius radiusMedium = BorderRadius.circular(radiusMediumValue);
  static final BorderRadius radiusLarge = BorderRadius.circular(radiusLargeValue);

  // ==========================================
  // TOKENS SEMÁNTICOS
  // ==========================================
  static final BorderRadius radiusButton = radiusMedium;  // 8.0
  static final BorderRadius radiusCard = radiusLarge;     // 16.0
  static final BorderRadius radiusBadge = radiusSmall;    // 4.0
}
