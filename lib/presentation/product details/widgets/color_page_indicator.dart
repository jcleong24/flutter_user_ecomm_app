import 'package:flutter/material.dart';
import 'package:flutter_user_ecomm_app/core/theme/color_manager.dart';

class ColorPageIndicatorItem extends StatelessWidget {
  final Color color;
  final bool isActive;
  final VoidCallback? onTap;
  final double size;
  final double activeBorderWidth;
  final double inactiveBorderWidth;
  final Color activeBorderColor;
  final Color inactiveBorderColor;
  final BorderRadius? borderRadius;

  const ColorPageIndicatorItem({
    super.key,
    required this.color,
    this.isActive = false,
    this.onTap,
    this.size = 12,
    this.activeBorderWidth = 2,
    this.inactiveBorderWidth = 1,
    this.activeBorderColor = Colors.transparent,
    this.inactiveBorderColor = Colors.transparent,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            borderRadius: borderRadius ?? BorderRadius.circular(8),
            border: Border.all(
              width: isActive ? activeBorderWidth : inactiveBorderWidth,
              color: isActive ? activeBorderColor : inactiveBorderColor,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: isActive
              ? const Center(
                  child: Icon(
                    Icons.check,
                    size: 16,
                    color: ColorManager.primary,
                  ),
                )
              : null,
        ));
  }
}

class ColorPageIndicatorRow extends StatelessWidget {
  final List<Color> colors;
  final int currentIndex;
  final ValueChanged<int>? onSelected;
  final double size;
  final double spacing;

  const ColorPageIndicatorRow({
    super.key,
    required this.colors,
    required this.currentIndex,
    this.onSelected,
    this.size = 40,
    this.spacing = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        colors.length,
        (index) => Padding(
          padding:
              EdgeInsets.only(right: index == colors.length - 1 ? 0 : spacing),
          child: ColorPageIndicatorItem(
            color: colors[index],
            isActive: currentIndex == index,
            size: size,
            onTap: onSelected == null ? null : () => onSelected!(index),
          ),
        ),
      ),
    );
  }
}
