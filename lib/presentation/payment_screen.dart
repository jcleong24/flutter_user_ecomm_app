import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/style_manager.dart';

import '../core/routers/route_name.dart';
import '../domain/bloc/payment/payment_bloc.dart';
import '../domain/bloc/payment/payment_event.dart';
import '../domain/bloc/payment/payment_state.dart';
import '../domain/enums/payment_status.dart';

class PaymentScreen extends StatelessWidget {
  final String orderId;
  final double amount;

  const PaymentScreen({
    super.key,
    required this.orderId,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment', style: StyleManager.headingSmall()),
      ),
      body: BlocConsumer<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state.status == PaymentStatus.submitted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Payment submitted. Waiting for confirmation...'),
              ),
            );
          } else if (state.status == PaymentStatus.approved) {
            context.go(RouteNames.paymentSuccess, extra: {
              'orderId': orderId,
              'amount': amount,
            });
          } else if (state.status == PaymentStatus.declined) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Payment Declined')),
            );
          } else if (state.status == PaymentStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Payment Error')),
            );
          }
        },
        builder: (context, state) {
          final isProcessing = state.status == PaymentStatus.initiated ||
              state.status == PaymentStatus.submitted;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'Order Summary',
                          style: StyleManager.headingSmall(),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Order ID', style: StyleManager.textSmall()),
                            Expanded(
                              child: Text(
                                orderId,
                                style: StyleManager.textSmall(),
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Amount',
                                style: StyleManager.textSmall()),
                            Text(
                              'RM ${amount.toStringAsFixed(2)}',
                              style: StyleManager.headingSmall(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                if (isProcessing) ...[
                  const Center(child: CircularProgressIndicator()),
                  const SizedBox(height: 12),
                  Text(
                    state.status == PaymentStatus.submitted
                        ? 'Waiting for Stripe webhook confirmation...'
                        : 'Preparing payment...',
                    style: StyleManager.textSmall(),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                ],
                ElevatedButton(
                  onPressed: isProcessing
                      ? null
                      : () async {
                          final bloc = context.read<PaymentBloc>();

                          // Step 1: create transaction first
                          bloc.add(
                            PaymentStartedEvent(
                              orderId: orderId,
                              amount: amount,
                            ),
                          );

                          // Give bloc a short moment to create transaction
                          await Future.delayed(
                            const Duration(milliseconds: 300),
                          );

                          // Step 2: call Stripe PaymentSheet
                          bloc.add(const PaymentStripConfirmedEvent());
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Pay with Card',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
