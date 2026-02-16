import 'package:flutter/material.dart';
import 'package:lumen_caeli/core/constants/app_colors.dart';

class AppTextStyles {
  static const fontFamily = 'OpenSans';

  // === Display ===

  /// Display Large - Open Sans 56/64 . -0.25
  static const displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 56,
    height: 64 / 56,
    letterSpacing: -0.25,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  /// Display Medium - Open Sans 44/52 . 0
  static const displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 44,
    height: 52 / 44,
    letterSpacing: 0,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  /// Display Small - Open Sans 36/44 . 0
  static const displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    height: 44 / 36,
    letterSpacing: 0,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  // === Headline ===

  /// Headline Large - Open Sans 32/40 . 0
  static const headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    height: 40 / 32,
    letterSpacing: 0,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  /// Headline Medium - Open Sans 28/36 . 0
  static const headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    height: 36 / 28,
    letterSpacing: 0,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  /// Headline Small - Open Sans 24/32 . 0
  static const headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    height: 32 / 24,
    letterSpacing: 0,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  /// Headline Small Bold- Open Sans 24/32 . 0
  static const headlineSmallBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    height: 32 / 24,
    letterSpacing: 0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // === Title ===

  /// Title Large - Open Sans SemiBold 22/28 . 0
  static const titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    height: 28 / 22,
    letterSpacing: 0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Title Medium - Open Sans SemiBold 16/24 . +0.15
  static const titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 24 / 16,
    letterSpacing: 0.15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Title Small - Open Sans SemiBold 14/20 . +0.1
  static const titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    height: 20 / 14,
    letterSpacing: 0.1,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // === Label ===

  /// Label Large - Open Sans SemiBold 14/20 . +0.1
  static const labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    height: 20 / 14,
    letterSpacing: 0.1,
    fontWeight: FontWeight.w600,
  );

  /// Label Medium - Open Sans SemiBold 12/16 . +0.5
  static const labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    height: 16 / 12,
    letterSpacing: 0.5,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Label Small - Open Sans SemiBold 11/16 . +0.5
  static const labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    height: 16 / 11,
    letterSpacing: 0.5,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // === Body ===

  /// Body Large - Open Sans 16/24 . +0.5
  static const bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 24 / 16,
    letterSpacing: 0.5,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  /// Body Medium - Open Sans 14/20 . +0.25
  static const bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    height: 20 / 14,
    letterSpacing: 0.25,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  /// Body Small - Open Sans 12/16 . +0.4
  static const bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    height: 16 / 12,
    letterSpacing: 0.4,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );
}
