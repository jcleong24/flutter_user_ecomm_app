import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/style_manager.dart';

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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment Approved (Stripe)')),
            );
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
          final isInitiated = state.transactionId != null;
          final isWaitingConfirmation = state.status == PaymentStatus.submitted;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Order: $orderId', style: StyleManager.textSmall()),
                const SizedBox(height: 8),
                Text(
                  'Amount: RM ${amount.toStringAsFixed(2)}',
                  style: StyleManager.headingSmall(),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: (state.status == PaymentStatus.initiated ||
                          isWaitingConfirmation)
                      ? null
                      : () {
                          context.read<PaymentBloc>().add(
                                PaymentStartedEvent(
                                  orderId: orderId,
                                  amount: amount,
                                ),
                              );
                        },
                  child:
                      Text(isInitiated ? 'Payment Initiated' : 'Start Payment'),
                ),
                const SizedBox(height: 16),
                Text(
                  'TransactionId: ${state.transactionId ?? '-'}',
                  style: StyleManager.textSmall(),
                ),
                const SizedBox(height: 12),
                Text(
                  'Status: ${state.status.name}',
                  style: StyleManager.textSmall(),
                ),
                const SizedBox(height: 24),
                if (isWaitingConfirmation) ...[
                  const Center(child: CircularProgressIndicator()),
                  const SizedBox(height: 12),
                  Text(
                    'Waiting for Stripe webhook confirmation...',
                    style: StyleManager.textSmall(),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                ],
                ElevatedButton(
                  onPressed: (!isInitiated || isWaitingConfirmation)
                      ? null
                      : () {
                          context.read<PaymentBloc>().add(
                                const PaymentStripConfirmedEvent(),
                              );
                        },
                  child: const Text('Pay with Card (Stripe Sandbox)'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: (!isInitiated || isWaitingConfirmation)
                      ? null
                      : () {
                          context.read<PaymentBloc>().add(
                                const PaymentMockDeclinedEvent(
                                  reason: 'Insufficient funds',
                                ),
                              );
                        },
                  child: const Text('Mock Decline'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
