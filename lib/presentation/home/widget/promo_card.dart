import 'package:flutter/material.dart';
import 'package:flutter_user_ecomm_app/core/theme/color_manager.dart';
import 'package:flutter_user_ecomm_app/core/theme/style_manager.dart';

class PromoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onShopNowPressed;
  final VoidCallback? onIconPressed;

  const PromoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onShopNowPressed,
    this.onIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorManager.primary,
            ColorManager.primaryVariant,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: StyleManager.headingSmall().copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: StyleManager.button().copyWith(
                        color: ColorManager.whiteTransparent,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: onShopNowPressed,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: ColorManager.borderTransparent,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          'Shop Now',
                          style: StyleManager.button().copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Material(
              color: Colors.transparent,
              child: Ink(
                decoration: const ShapeDecoration(
                  color: ColorManager.borderTransparent,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  iconSize: 35,
                  icon: Icon(icon),
                  color: ColorManager.white,
                  onPressed: onIconPressed,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
