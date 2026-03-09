import 'package:flutter/material.dart';
import 'package:flutter_user_ecomm_app/core/theme/color_manager.dart';
import 'package:flutter_user_ecomm_app/core/theme/style_manager.dart';

class ReviewProductCard extends StatelessWidget {
  final String reviewerName;
  final String reviewDate;
  final String reviewText;
  final double rating;
  final String avatarUrl;

  const ReviewProductCard({
    super.key,
    required this.reviewerName,
    required this.reviewDate,
    required this.reviewText,
    required this.rating,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: ColorManager.border.withValues(alpha: 0.25),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.network(
                  avatarUrl,
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ColorManager.border.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person_outline),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reviewerName,
                      style: StyleManager.textMedium(),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      reviewDate,
                      style: StyleManager.caption(),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: ColorManager.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rating.toStringAsFixed(1),
                      style: StyleManager.caption(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            reviewText,
            style: StyleManager.textExtraSmall(),
          ),
        ],
      ),
    );
  }
}
