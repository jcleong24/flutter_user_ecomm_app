import 'package:flutter/material.dart';
import 'package:flutter_user_ecomm_app/domain/models/product.dart';
import '../../../core/theme/color_manager.dart';
import '../../../core/theme/style_manager.dart';

class TrendingCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const TrendingCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
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
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      color: ColorManager.backgroundColor.withOpacity(0.35),
                      child: product.imageUrl.isNotEmpty
                          ? Image.network(
                              product.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 32,
                                    color: ColorManager.primary,
                                  ),
                                );
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Icon(
                                Icons.image_outlined,
                                size: 32,
                                color: ColorManager.primary,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  product.name,
                  style: StyleManager.caption().copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  'RM ${product.price.toStringAsFixed(2)}',
                  style: StyleManager.caption().copyWith(
                    color: ColorManager.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
