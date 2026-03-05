import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_user_ecomm_app/core/routers/route_name.dart';
import 'package:flutter_user_ecomm_app/core/theme/style_manager.dart';
import 'package:flutter_user_ecomm_app/domain/bloc/cart/cart_event.dart';
import 'package:go_router/go_router.dart';

import '../domain/bloc/cart/cart_bloc.dart';
import '../domain/bloc/cart/cart_state.dart';
import '../domain/bloc/order/order_bloc.dart';
import '../domain/bloc/order/order_event.dart';
import '../domain/bloc/order/order_state.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state.status == OrderSubmitStatus.success) {
          final orderId = state.orderId;

          if (orderId == null) return;

          final totalAmount = context.read<CartBloc>().state.totalAmount;
          debugPrint('NAV payment extra: orderId=$orderId amount=$totalAmount');
          // Navigate back to payment screen
          context.push(RouteNames.payment, extra: {
            'orderId': orderId,
            'amount': totalAmount,
          });

          context.read<CartBloc>().add(const CartClearedEvent());

          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('Order created: ${state.orderId}')),
          // );
        }

        if (state.status == OrderSubmitStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Order failed!')),
          );
        }
      },
      child: Scaffold(
        appBar:
            AppBar(title: Text('Checkout', style: StyleManager.headingSmall())),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state.isEmpty) {
              return Center(
                child: Text(
                  'Your cart is empty!',
                  style: StyleManager.textSmall(),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Order Summary', style: StyleManager.headingSmall()),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (_, __) => const Divider(),
                      itemCount: state.cartItems.length,
                      itemBuilder: (context, index) {
                        final item = state.cartItems[index];
                        return ListTile(
                          title: Text(item.product.name),
                          subtitle: Text(
                            '${item.quantity} x RM ${item.product.price.toStringAsFixed(2)}',
                            style: StyleManager.textSmall(),
                          ),
                          trailing: Text(
                            'RM ${(item.quantity * item.product.price).toStringAsFixed(2)}',
                            style: StyleManager.textSmall(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  _CheckoutTotalRow(
                    label: 'Items',
                    value: '${state.totalQuantity}',
                  ),
                  const SizedBox(height: 6),
                  _CheckoutTotalRow(
                    label: 'Total',
                    value: 'RM ${state.totalAmount.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<OrderBloc, OrderState>(
                    builder: (context, orderState) {
                      final isSubmitting =
                          orderState.status == OrderSubmitStatus.submitting;

                      return ElevatedButton(
                        onPressed: isSubmitting
                            ? null
                            : () {
                                context
                                    .read<OrderBloc>()
                                    .add(OrderPlacedEvent(state.cartItems));
                              },
                        child: isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator())
                            : const Text('Place Order'),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CheckoutTotalRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _CheckoutTotalRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final style =
        isBold ? StyleManager.headingSmall() : StyleManager.textSmall();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    );
  }
}
