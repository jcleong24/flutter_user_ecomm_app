import 'package:flutter/material.dart';
import 'package:flutter_user_ecomm_app/core/theme/color_manager.dart';
import 'package:flutter_user_ecomm_app/core/theme/style_manager.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback onCartPressed;
  final VoidCallback onNotificationPressed;

  const HomeHeader({
    super.key,
    required this.onCartPressed,
    required this.onNotificationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Find the best products',
            style: StyleManager.headingSemiMedium(),
            textAlign: TextAlign.start,
          ),
        ),
        Row(
          children: [
            Ink(
              decoration: const ShapeDecoration(
                color: ColorManager.borderButton,
                shape: CircleBorder(),
              ),
              child: IconButton(
                icon: const Icon(Icons.shopping_bag_outlined),
                color: ColorManager.primary,
                onPressed: onCartPressed,
              ),
            ),
            const SizedBox(width: 12),
            Ink(
              decoration: const ShapeDecoration(
                color: ColorManager.borderButton,
                shape: CircleBorder(),
              ),
              child: IconButton(
                icon: const Icon(Icons.notifications_outlined),
                color: ColorManager.primary,
                onPressed: onNotificationPressed,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
