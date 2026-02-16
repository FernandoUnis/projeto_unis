import 'package:flutter/material.dart';
import 'package:lumen_caeli/core/constants/app_colors.dart';
import 'package:lumen_caeli/core/theme/app_input_theme.dart';
import 'package:lumen_caeli/core/theme/app_text_styles.dart';

class AppTheme {
  static ThemeData themeData({String? fontFamily}) {
    final selectedFontFamily = fontFamily ?? AppTextStyles.fontFamily;
    return ThemeData(
      colorSchemeSeed: AppColors.primaryColor,
      textTheme: appTextTheme(selectedFontFamily),
      fontFamily: selectedFontFamily,
      appBarTheme: appBarTheme(selectedFontFamily),
      scaffoldBackgroundColor: AppColors.backgroundDefault,
      elevatedButtonTheme: elevatedButtonThemeData(),
      inputDecorationTheme: AppInputTheme.defaultTheme,

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.primaryDark,
        contentTextStyle: TextStyle(color: AppColors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 4.0,
        behavior: SnackBarBehavior.floating,
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  static TextTheme appTextTheme(String fontFamily) {
    return TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(fontFamily: fontFamily),
      displayMedium: AppTextStyles.displayMedium.copyWith(
        fontFamily: fontFamily,
      ),
      displaySmall: AppTextStyles.displaySmall.copyWith(fontFamily: fontFamily),
      headlineLarge: AppTextStyles.headlineLarge.copyWith(
        fontFamily: fontFamily,
      ),
      headlineMedium: AppTextStyles.headlineMedium.copyWith(
        fontFamily: fontFamily,
      ),
      headlineSmall: AppTextStyles.headlineSmall.copyWith(
        fontFamily: fontFamily,
      ),
      titleLarge: AppTextStyles.titleLarge.copyWith(fontFamily: fontFamily),
      titleMedium: AppTextStyles.titleMedium.copyWith(fontFamily: fontFamily),
      titleSmall: AppTextStyles.titleSmall.copyWith(fontFamily: fontFamily),
      labelLarge: AppTextStyles.labelLarge.copyWith(fontFamily: fontFamily),
      labelMedium: AppTextStyles.labelMedium.copyWith(fontFamily: fontFamily),
      labelSmall: AppTextStyles.labelSmall.copyWith(fontFamily: fontFamily),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(fontFamily: fontFamily),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(fontFamily: fontFamily),
      bodySmall: AppTextStyles.bodySmall.copyWith(fontFamily: fontFamily),
    );
  }

  static ElevatedButtonThemeData elevatedButtonThemeData() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
      ),
    );
  }

  static AppBarTheme appBarTheme(String fontFamily) {
    return AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: AppColors.textOnPrimary),
      titleTextStyle: AppTextStyles.titleLarge.copyWith(
        fontFamily: fontFamily,
        color: AppColors.textOnPrimary,
      ),
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
    );
  }
}
