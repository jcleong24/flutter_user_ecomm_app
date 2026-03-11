import 'package:flutter/material.dart';

class ColorManager {
  // Brand
  static const Color primary = Color(0xCCFF7622);
  static const Color primaryVariant = Color(0xFF7C3AED);
  static Color primaryTransparent = primary.withValues(alpha: 0.35);
  static const Color secondary = Color(0xFFFFD1B4);

  // Background
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static Color backgroundColorTransparent =
      backgroundColor.withValues(alpha: 0.1);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xCC111827);
  static const Color textSecondary = Color(0xCC6B7280);
  static const Color borderButton = Color(0xCCE5E7EB);
  static Color borderButtonTransparent = borderButton.withValues(alpha: 0.5);

  static Color border = Colors.grey.withValues(alpha: 0.35);
  static Color borderTransparent = border.withValues(alpha: 0.8);

  static const Color white = Color(0xFFFFFFFF);
  static const Color whiteTransparent = Color(0xE5FFFFFF);
  // static Color border = Colors.white.withValues(alpha : 0.16);

  // Status
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFDC2626);

  // static const Color border100 = Color(0xFFE5E7EB); // 100%
  // static const Color border80 = Color(0xCCE5E7EB); // 80%
  // static const Color border60 = Color(0x99E5E7EB); // 60%
  // static const Color border50 = Color(0x80E5E7EB); // 50%
  // static const Color border30 = Color(0x4DE5E7EB); // 30%
  // static const Color border20 = Color(0x33E5E7EB); // 20%
}
