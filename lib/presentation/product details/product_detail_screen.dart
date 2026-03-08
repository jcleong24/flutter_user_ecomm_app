import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_user_ecomm_app/core/theme/color_manager.dart';
import 'package:flutter_user_ecomm_app/domain/bloc/cart/cart_bloc.dart';
import 'package:flutter_user_ecomm_app/presentation/cart/widgets/cart_icon_button.dart';
import 'package:flutter_user_ecomm_app/presentation/widgets/custom_app_bar.dart';

import '../../core/theme/style_manager.dart';
import '../../domain/bloc/cart/cart_event.dart';
import '../../domain/bloc/product/product_bloc.dart';
import '../../domain/bloc/product/product_event.dart';
import '../../domain/bloc/product/product_state.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailsScreen> {
  late final PageController _pageController;
  int _currentPage = 0;

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
      appBar: const CustomAppBar(
        title: '',
        trailingWidget: CartIconButton(),
        // trailingIcon: Icons.shopping_cart_outlined,
        // onTrailingPressed: () {
        //   Navigator.pop(context);
        // },
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          switch (state.selectedProductStatus) {
            case ProductStatus.onLoading:
              return const Center(child: CircularProgressIndicator());
            case ProductStatus.onLoaded:
              final product = state.selectedProduct!;
              return Container(
                  decoration: BoxDecoration(
                    color: ColorManager.backgroundColorTransparent,
                    // borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 320,
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
                            final imageUrls = product.imageUrls[index];

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
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    imageUrls,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Center(
                                      child: Icon(
                                          Icons.image_not_supported_outlined,
                                          size: 32),
                                    ),
                                  )),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(product.name, style: StyleManager.headingSmall()),
                      const SizedBox(height: 12),
                      Text(product.description,
                          style: StyleManager.textSmall()),
                      const SizedBox(height: 12),
                      Text('RM ${product.price.toStringAsFixed(2)}',
                          style: StyleManager.headingSmall()),
                      const SizedBox(height: 12),
                      Text('Stock: ${product.stockQty}',
                          style: StyleManager.textSmall()),
                      const Spacer(),
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
                                content: Text('${product.name} added to cart'),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ));
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
