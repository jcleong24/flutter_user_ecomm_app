import 'package:flutter/material.dart';
import 'package:flutter_user_ecomm_app/core/theme/color_manager.dart';

class PromoIndicator extends StatelessWidget {
  final bool isActive;

  const PromoIndicator({
    super.key,
    required this.isActive,
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
            ? ColorManager.primary
            : ColorManager.border.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
