import 'package:flutter/material.dart';

/// Tokens Primitivos y Semánticos de Color para SafeAccess 90.
abstract class AppColors {
  // ==========================================
  // TOKENS PRIMITIVOS (Valores base de paleta)
  // ==========================================

  // Primary Palette (Blue)
  static const Color blue50 = Color(0xFFEFF6FF);
  static const Color blue100 = Color(0xFFDBEAFE);
  static const Color blue500 = Color(0xFF3B82F6);
  static const Color blue700 = Color(0xFF1D4ED8);
  static const Color blue900 = Color(0xFF1E3A8A);

  // Neutral Palette (Slate)
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate900 = Color(0xFF0F172A);

  // White
  static const Color white = Color(0xFFFFFFFF);

  // Success Palette (Green)
  static const Color green50 = Color(0xFFF0FDF4);
  static const Color green100 = Color(0xFFDCFCE7);
  static const Color green700 = Color(0xFF15803D);
  static const Color green900 = Color(0xFF14532D);

  // Error Palette (Red)
  static const Color red50 = Color(0xFFFEF2F2);
  static const Color red100 = Color(0xFFFEE2E2);
  static const Color red700 = Color(0xFFB91C1C);
  static const Color red900 = Color(0xFF7F1D1D);

  // Warning Palette (Amber)
  static const Color amber50 = Color(0xFFFFFBEB);
  static const Color amber100 = Color(0xFFFEF3C7);
  static const Color amber700 = Color(0xFFB45309);
  static const Color amber900 = Color(0xFF78350F);

  // ==========================================
  // TOKENS SEMÁNTICOS (Basados en propósito)
  // ==========================================

  // Brand / Main Actions
  static const Color colorPrimary = blue700;
  static const Color colorOnPrimary = white;
  static const Color colorPrimaryContainer = blue50;
  static const Color colorOnPrimaryContainer = blue900;

  // Background & Surfaces
  static const Color colorBackground = slate50;
  static const Color colorOnBackground = slate900;
  static const Color colorSurface = white;
  static const Color colorOnSurface = slate900;
  static const Color colorSurfaceVariant = slate100;
  static const Color colorOnSurfaceVariant = slate600;

  // Typography
  static const Color colorTextPrimary = slate900;
  static const Color colorTextSecondary = slate600;

  // Borders & Dividers
  static const Color colorBorder = slate200;

  // Status: Success
  static const Color colorSuccess = green700;
  static const Color colorOnSuccess = white;
  static const Color colorSuccessContainer = green50;
  static const Color colorOnSuccessContainer = green900;

  // Status: Error
  static const Color colorError = red700;
  static const Color colorOnError = white;
  static const Color colorErrorContainer = red50;
  static const Color colorOnErrorContainer = red900;

  // Status: Warning
  static const Color colorWarning = amber700;
  static const Color colorOnWarning = white;
  static const Color colorWarningContainer = amber50;
  static const Color colorOnWarningContainer = amber900;
}
