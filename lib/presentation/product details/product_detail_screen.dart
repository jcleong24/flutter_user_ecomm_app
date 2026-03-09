import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_user_ecomm_app/core/theme/color_manager.dart';
import 'package:flutter_user_ecomm_app/domain/bloc/cart/cart_bloc.dart';
import 'package:flutter_user_ecomm_app/presentation/product%20details/widgets/cart_icon_button.dart';
import 'package:flutter_user_ecomm_app/presentation/widgets/custom_app_bar.dart';

import '../../core/theme/style_manager.dart';
import '../../domain/bloc/cart/cart_event.dart';
import '../../domain/bloc/product/product_bloc.dart';
import '../../domain/bloc/product/product_event.dart';
import '../../domain/bloc/product/product_state.dart';
import 'widgets/product_image_carousel.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailsScreen> {
  late final PageController _pageController;

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
                    children: [
                      ProductImageCarousel(
                        imageUrls: product.imageUrls,
                        height: 380,
                      ),
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
                            Text(product.name,
                                style: StyleManager.headingSmall()),
                            const SizedBox(height: 12),
                            Text(product.description,
                                style: StyleManager.textSmall()),
                            const SizedBox(height: 12),
                            Text(
                              'RM ${product.price.toStringAsFixed(2)}',
                              style: StyleManager.headingSmall(),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Stock: ${product.stockQty}',
                              style: StyleManager.textSmall(),
                            ),
                            const SizedBox(height: 24),
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
