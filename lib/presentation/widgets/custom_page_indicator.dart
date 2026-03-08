import 'package:flutter/material.dart';
import 'package:flutter_user_ecomm_app/core/theme/color_manager.dart';

class CustomPageIndicator extends StatelessWidget {
  final bool isActive;
  final Color? activeColor;
  final Color? inactiveColor;
  final EdgeInsetsGeometry margin;
  final double borderRadius;

  const CustomPageIndicator({
    super.key,
    required this.isActive,
    this.activeColor,
    this.inactiveColor,
    this.margin = const EdgeInsets.symmetric(horizontal: 3),
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: isActive ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? (activeColor ?? ColorManager.primary)
            : (inactiveColor ?? ColorManager.borderButton),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
