import 'package:flutter/material.dart';
import 'package:flutter_user_ecomm_app/core/theme/color_manager.dart';
import 'package:flutter_user_ecomm_app/core/theme/font_manager.dart';
import 'package:flutter_user_ecomm_app/core/theme/values_manager.dart';

class AppTheme {
  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: ColorManager.backgroundColor,
      colorScheme: base.colorScheme.copyWith(
          primary: ColorManager.primary,
          secondary: ColorManager.secondary,
          surface: ColorManager.surface,
          error: ColorManager.error),
      textTheme: base.textTheme.apply(
          fontFamily: FontConstants.fontFamily,
          bodyColor: ColorManager.textPrimary,
          displayColor: ColorManager.textPrimary),
      appBarTheme: const AppBarTheme(
          backgroundColor: ColorManager.surface,
          foregroundColor: ColorManager.textPrimary,
          elevation: 0,
          centerTitle: false),
      cardTheme: CardTheme(
        color: ColorManager.surface,
        elevation: AppElevation.e2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r16),
          side: const BorderSide(color: ColorManager.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorManager.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.r12),
          borderSide: const BorderSide(color: ColorManager.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.r12),
          borderSide: const BorderSide(color: ColorManager.border),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.r12),
          ),
        ),
      ),
    );
  }
}
