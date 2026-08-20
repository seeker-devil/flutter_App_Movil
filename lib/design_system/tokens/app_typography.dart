import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Tokens Primitivos y Semánticos de Tipografía para SafeAccess 90.
abstract class AppTypography {
  // ==========================================
  // TOKENS PRIMITIVOS
  // ==========================================
  static const double fontSizeSmall = 12.0;
  static const double fontSizeBody = 14.0;
  static const double fontSizeTitle = 18.0;
  static const double fontSizeHeadline = 22.0;

  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightBold = FontWeight.w700;

  // ==========================================
  // TOKENS SEMÁNTICOS DE ESTILO DE TEXTO
  // ==========================================
  static const TextStyle headline = TextStyle(
    fontSize: fontSizeHeadline,
    fontWeight: fontWeightBold,
    color: AppColors.colorTextPrimary,
    height: 1.3,
  );

  static const TextStyle title = TextStyle(
    fontSize: fontSizeTitle,
    fontWeight: fontWeightMedium,
    color: AppColors.colorTextPrimary,
    height: 1.3,
  );

  static const TextStyle body = TextStyle(
    fontSize: fontSizeBody,
    fontWeight: fontWeightRegular,
    color: AppColors.colorTextPrimary,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontSize: fontSizeSmall,
    fontWeight: fontWeightRegular,
    color: AppColors.colorTextSecondary,
    height: 1.4,
  );

  static const TextStyle button = TextStyle(
    fontSize: fontSizeBody,
    fontWeight: fontWeightMedium,
    color: AppColors.colorOnPrimary,
  );
}
