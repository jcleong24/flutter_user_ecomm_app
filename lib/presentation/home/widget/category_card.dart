import 'package:flutter/material.dart';
import '../../../core/theme/color_manager.dart';
import '../../../core/theme/style_manager.dart';

class CategoryCardData {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const CategoryCardData({
    required this.title,
    required this.icon,
    this.onTap,
  });
}

class CategoryCard extends StatelessWidget {
  final CategoryCardData data;

  const CategoryCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 132,
      decoration: BoxDecoration(
        color: ColorManager.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ColorManager.border.withOpacity(0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: data.onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: ColorManager.primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  data.icon,
                  color: ColorManager.primary,
                  size: 26,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                data.title,
                style: StyleManager.button(),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
