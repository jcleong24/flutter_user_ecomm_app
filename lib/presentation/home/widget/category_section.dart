import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routers/route_name.dart';
import '../../../core/theme/style_manager.dart';
import 'category_card.dart';

class CategorySection extends StatelessWidget {
  final List<CategoryCardData> categories;
  final String title;

  const CategorySection({
    super.key,
    required this.categories,
    this.title = 'Categories',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: StyleManager.headingSmall(),
            ),
            InkWell(
              onTap: () {
                context.push(RouteNames.home);
              },
              child: Text(
                'View All',
                style: StyleManager.caption(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final crossAxisCount = width >= 600 ? 4 : 2;
            const spacing = 12.0;

            final itemWidth =
                (width - (spacing * (crossAxisCount - 1))) / crossAxisCount;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: categories
                  .map(
                    (category) => SizedBox(
                      width: itemWidth,
                      child: CategoryCard(data: category),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}
