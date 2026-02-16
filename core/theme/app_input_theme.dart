import 'package:flutter/material.dart';
import 'package:lumen_caeli/core/constants/app_colors.dart';

class AppInputTheme {
  static final defaultTheme = InputDecorationTheme(
    hintStyle: const TextStyle(color: AppColors.neutralGray),
    fillColor: AppColors.white,
    labelStyle: const TextStyle(color: AppColors.neutralGray),
    errorStyle: const TextStyle(color: AppColors.alertError),
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    disabledBorder: defaultInputBorder.copyWith(
      borderSide: const BorderSide(color: AppColors.neutralGray),
    ),
    enabledBorder: defaultInputBorder.copyWith(
      borderSide: const BorderSide(color: AppColors.neutralGray),
    ),

    focusedBorder: defaultInputBorder.copyWith(
      borderSide: BorderSide(color: AppColors.primaryColor),
    ),
    errorBorder: defaultInputBorder.copyWith(
      borderSide: const BorderSide(color: AppColors.neutralGray),
    ),
    focusedErrorBorder: defaultInputBorder.copyWith(
      borderSide: const BorderSide(color: AppColors.alertError),
    ),
    isDense: true,
    contentPadding: const EdgeInsets.all(12),
  );

  static const onPrimary = InputDecorationTheme(
    hintStyle: TextStyle(color: AppColors.neutralLight),
    fillColor: AppColors.white,
    labelStyle: TextStyle(color: AppColors.neutralLight),
    errorStyle: TextStyle(color: AppColors.alertError),
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.neutralGray),
      borderRadius: borderRadius,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.white),
      borderRadius: borderRadius,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.white),
      borderRadius: borderRadius,
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.neutralGray),
      borderRadius: borderRadius,
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.alertError),
      borderRadius: borderRadius,
    ),

    isDense: true,
    contentPadding: EdgeInsets.all(12),
  );

  static const defaultInputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.white),
    borderRadius: borderRadius,
  );
  static const borderRadius = BorderRadius.all(Radius.circular(30.0));
}
