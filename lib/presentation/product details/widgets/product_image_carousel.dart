import 'package:flutter/material.dart';
import 'package:flutter_user_ecomm_app/core/theme/color_manager.dart';

import '../../../domain/models/product.dart';
import '../../widgets/custom_page_indicator.dart';

class ProductImageCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final double height;

  const ProductImageCarousel({
    super.key,
    required this.imageUrls,
    this.height = 200,
  });

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) {
      return Container(
        height: widget.height,
        width: double.infinity,
        color: ColorManager.backgroundColor,
        alignment: Alignment.center,
        child: const Icon(Icons.image_not_supported_outlined, size: 40),
      );
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: 380,
        width: double.infinity,
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.imageUrls.length,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          itemBuilder: (context, index) {
            final imageUrl = widget.imageUrls[index];

            return AnimatedBuilder(
              animation: _pageController,
              builder: (context, child) {
                double scale = 1.0;

                if (_pageController.hasClients &&
                    _pageController.position.haveDimensions) {
                  final page = _pageController.page ?? _currentPage.toDouble();
                  final diff = (page - index).abs();
                  scale = (1 - (diff * 0.06)).clamp(0.9, 1.0);
                }

                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 32,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 12),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.imageUrls.length,
          (index) => CustomPageIndicator(
            isActive: _currentPage == index,
          ),
        ),
      ),
    ]);
  }
}
