import 'package:flutter/material.dart';
import 'package:flutter_user_ecomm_app/domain/models/product.dart';
import 'package:flutter_user_ecomm_app/presentation/home/widget/trending_card.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routers/route_name.dart';

class TrendingSection extends StatefulWidget {
  final List<Product> products;

  const TrendingSection({
    super.key,
    required this.products,
  });

  @override
  State<TrendingSection> createState() => _TrendingSectionState();
}

class _TrendingSectionState extends State<TrendingSection> {
  final PageController _pageController = PageController(viewportFraction: 1.0);
  int _currentPage = 0;

  static const int _itemsPerPage = 2;

  List<List<Product>> _chunkProducts(List<Product> products) {
    final List<List<Product>> chunks = [];

    for (int i = 0; i < products.length; i += _itemsPerPage) {
      final end = (i + _itemsPerPage < products.length)
          ? i + _itemsPerPage
          : products.length;
      chunks.add(products.sublist(i, end));
    }

    return chunks;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) {
      return const SizedBox.shrink();
    }

    final pages = _chunkProducts(widget.products);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, pageIndex) {
              final pageProducts = pages[pageIndex];

              return GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pageProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) {
                  final product = pageProducts[index];

                  return TrendingCard(
                    product: product,
                    onTap: () {
                      context
                          .push('${RouteNames.productDetails}/${product.id}');
                      // handle navigation here
                    },
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            pages.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentPage == index ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? Theme.of(context).primaryColor
                    : Colors.grey.withOpacity(0.35),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
