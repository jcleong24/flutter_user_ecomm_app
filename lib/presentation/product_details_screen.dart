import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_user_ecomm_app/domain/bloc/cart/cart_bloc.dart';
import 'package:flutter_user_ecomm_app/presentation/cart/widgets/cart_icon_button.dart';

import '../core/theme/style_manager.dart';
import '../domain/bloc/cart/cart_event.dart';
import '../domain/bloc/product/product_bloc.dart';
import '../domain/bloc/product/product_event.dart';
import '../domain/bloc/product/product_state.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(ProductDetailsRequested(widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details', style: StyleManager.headingSmall()),
        actions: const [CartIconButton()],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          switch (state.selectedProductStatus) {
            case ProductStatus.onLoading:
              return const Center(child: CircularProgressIndicator());
            case ProductStatus.onLoaded:
              final product = state.selectedProduct!;
              return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name, style: StyleManager.headingSmall()),
                      const SizedBox(height: 8),
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
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
