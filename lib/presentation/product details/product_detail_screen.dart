import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_user_ecomm_app/core/theme/color_manager.dart';
import 'package:flutter_user_ecomm_app/domain/bloc/cart/cart_bloc.dart';
import 'package:flutter_user_ecomm_app/presentation/product%20details/widgets/cart_icon_button.dart';
import 'package:flutter_user_ecomm_app/presentation/product%20details/widgets/color_page_indicator.dart';
import 'package:flutter_user_ecomm_app/presentation/widgets/custom_app_bar.dart';

import '../../core/theme/style_manager.dart';
import '../../domain/bloc/cart/cart_event.dart';
import '../../domain/bloc/product/product_bloc.dart';
import '../../domain/bloc/product/product_event.dart';
import '../../domain/bloc/product/product_state.dart';
import '../widgets/custom_page_indicator.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailsScreen> {
  late final PageController _pageController;
  int _currentPage = 0;

  final List<Color> _productColors = [
    Colors.white,
    const Color.fromARGB(255, 242, 202, 57),
    Colors.black,
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    context.read<ProductBloc>().add(ProductDetailsRequested(widget.productId));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(
        title: '',
        backgroundColor: Colors.transparent,
        iconColor: Colors.white,
        trailingWidget: CartIconButton(iconColor: ColorManager.white),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          switch (state.selectedProductStatus) {
            case ProductStatus.onLoading:
              return const Center(child: CircularProgressIndicator());
            case ProductStatus.onLoaded:
              final product = state.selectedProduct!;

              return Container(
                color: ColorManager.backgroundColorTransparent,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 380,
                        width: double.infinity,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: product.imageUrls.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            final imageUrl = product.imageUrls[index];
                            return AnimatedBuilder(
                              animation: _pageController,
                              builder: (context, child) {
                                double scale = 1.0;
                                if (_pageController.hasClients &&
                                    _pageController.position.haveDimensions) {
                                  final page = _pageController.page ??
                                      _currentPage.toDouble();
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
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) =>
                                    const Center(
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
                            product.imageUrls.length,
                            (index) => CustomPageIndicator(
                              isActive: _currentPage == index,
                            ),
                          )),
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: ColorManager.backgroundColor,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(product.name,
                                      style: StyleManager.headingSmall()),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'RM ${product.price.toStringAsFixed(2)}',
                                  style: StyleManager.caption(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(product.description,
                                style: StyleManager.textSmall()),
                            const SizedBox(height: 12),
                            Text('Color',
                                style: StyleManager.headingExtraSmall()),
                            const SizedBox(height: 8),
                            ColorPageIndicatorRow(
                                colors: _productColors,
                                currentIndex: _currentPage,
                                onSelected: (index) {
                                  _pageController.animateToPage(index,
                                      duration:
                                          const Duration(milliseconds: 220),
                                      curve: Curves.easeInOut);
                                }),
                            const SizedBox(height: 12),
                            Text(
                              'Available: ${product.stockQty}',
                              style: StyleManager.textSmall(),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.add_shopping_cart),
                                label: const Text('Add to Cart'),
                                onPressed: () {
                                  context
                                      .read<CartBloc>()
                                      .add(CartItemAddedEvent(product));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('${product.name} added to cart'),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            case ProductStatus.error:
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.selectedProductErrorMsg ??
                        'Failed to load product'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<ProductBloc>()
                            .add(ProductDetailsRequested(widget.productId));
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            case ProductStatus.initial:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
