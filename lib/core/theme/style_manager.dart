import 'package:flutter/widgets.dart';
import 'package:flutter_user_ecomm_app/core/theme/color_manager.dart';
import 'package:flutter_user_ecomm_app/core/theme/font_manager.dart';

class StyleManager {
  static TextStyle _base({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
    required height,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? ColorManager.textPrimary,
      height: height,
    );
  }

  // Text
  static TextStyle textSmall() =>
      _base(fontSize: 14, fontWeight: FontWeightManager.regular, height: 1.5);
  static TextStyle textSemiMedium() =>
      _base(fontSize: 16, fontWeight: FontWeightManager.regular, height: 1.5);
  static TextStyle textMedium() =>
      _base(fontSize: 16, fontWeight: FontWeightManager.medium, height: 1.5);
  static TextStyle textLarge() =>
      _base(fontSize: 20, fontWeight: FontWeightManager.medium, height: 1.5);
  static TextStyle textExtraLarge() =>
      _base(fontSize: 24, fontWeight: FontWeightManager.medium, height: 1.5);

  // Heading
  static TextStyle headingSmall() =>
      _base(fontSize: 20, fontWeight: FontWeightManager.medium, height: 1.5);
  static TextStyle headingSemiMedium() =>
      _base(fontSize: 20, fontWeight: FontWeightManager.semibold, height: 1.5);
  static TextStyle headingMedium() =>
      _base(fontSize: 24, fontWeight: FontWeightManager.semibold, height: 1.5);
  static TextStyle headingLarge() =>
      _base(fontSize: 28, fontWeight: FontWeightManager.bold, height: 1.5);

  // Labels / Buttons\
  static TextStyle button() => _base(
      fontSize: 14,
      fontWeight: FontWeightManager.medium,
      height: 1.5,
      color: ColorManager.primary);

  static TextStyle caption() => _base(
      fontSize: 12,
      fontWeight: FontWeightManager.medium,
      height: 1.5,
      color: ColorManager.textSecondary);
}
