import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_user_ecomm_app/domain/bloc/cart/cart_event.dart';

import '../../core/theme/style_manager.dart';
import '../../domain/bloc/cart/cart_bloc.dart';
import '../../domain/bloc/cart/cart_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Cart', style: StyleManager.headingSmall()),
          actions: [
            BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                if (state.isEmpty) return const SizedBox.shrink();
                return TextButton(
                  onPressed: () =>
                      context.read<CartBloc>().add(const CartClearedEvent()),
                  child: const Text('Clear'),
                );
              },
            ),
          ]),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.isEmpty) {
            return Center(
              child: Text(
                "Your cart is empty",
                style: StyleManager.textSmall(),
              ),
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    addAutomaticKeepAlives: false,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemCount: state.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = state.cartItems[index];
                      final p = item.product;

                      return ListTile(
                        leading: ClipRect(
                          // borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            p.imageUrl,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 56,
                              height: 56,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.image_not_supported),
                            ),
                          ),
                        ),
                        title: Text(
                          p.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          'RM ${p.price.toStringAsFixed(2)}',
                          style: StyleManager.textSmall(),
                        ),
                        trailing: SizedBox(
                          // width: 160,
                          child: Wrap(
                            alignment: WrapAlignment.end,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  context
                                      .read<CartBloc>()
                                      .add(CartItemQtyDecreaseEvent(p));
                                },
                              ),
                              Text(
                                '${item.quantity}',
                                style: StyleManager.headingSmall(),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  context
                                      .read<CartBloc>()
                                      .add(CartItemQtyIncreaseEvent(p));
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () {
                                  context
                                      .read<CartBloc>()
                                      .add(CartItemRemovedEvent(p));
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Bottom sumary / checkout
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Product Item',
                                style: StyleManager.textSmall()),
                            Text('Quantity :${state.totalQuantity}',
                                style: StyleManager.textSmall()),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Amount',
                                style: StyleManager.headingSmall()),
                            Text(
                              'RM ${state.totalAmount.toStringAsFixed(2)}',
                              style: StyleManager.headingSmall(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            // next step: go checkout
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Checkout: coming next')),
                            );
                          },
                          child: const Text('Checkout'),
                        ),
                      ]),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
