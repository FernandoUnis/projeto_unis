import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lumen_caeli/core/constants/app_colors.dart';

enum StatusBarTheme {
  primary,
  onPrimary,
  transparent,
  secondary;

  SystemUiOverlayStyle style({Color? color}) {
    return switch (this) {
      StatusBarTheme.onPrimary => AppSystemUI.onPrimaryTheme(
        statusBarColor: color,
      ),
      StatusBarTheme.primary => AppSystemUI.primaryTheme(statusBarColor: color),
      StatusBarTheme.transparent => AppSystemUI.transparentTheme(),
      StatusBarTheme.secondary => AppSystemUI.secondaryTheme(),
    };
  }
}

class AppSystemUI {
  // Tema primário padrão
  static SystemUiOverlayStyle onPrimaryTheme({
    Color? statusBarColor,
    Color? navBarColor,
  }) {
    return SystemUiOverlayStyle(
      statusBarColor: AppColors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemStatusBarContrastEnforced: true,
    );
  }

  // Tema secundário padrão
  static SystemUiOverlayStyle primaryTheme({
    Color? statusBarColor,
    Color? navBarColor,
  }) {
    return SystemUiOverlayStyle(
      statusBarColor: AppColors.primaryColor,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark, // iOS
      systemNavigationBarColor: AppColors.primaryColor,
      systemNavigationBarIconBrightness: Brightness.light,
      systemStatusBarContrastEnforced: true,
    );
  }

  // Tema transparente
  static SystemUiOverlayStyle transparentTheme({Color? navBarColor}) {
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark, // iOS
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      systemStatusBarContrastEnforced: true,
    );
  }

  static SystemUiOverlayStyle secondaryTheme() {
    return SystemUiOverlayStyle(
      statusBarColor: AppColors.primaryColor,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemStatusBarContrastEnforced: true,
    );
  }
}
