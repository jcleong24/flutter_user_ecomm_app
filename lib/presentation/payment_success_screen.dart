import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routers/route_name.dart';
import '../../../core/theme/style_manager.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String orderId;
  final double amount;

  const PaymentSuccessScreen({
    super.key,
    required this.orderId,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const CircleAvatar(
                radius: 42,
                child: Icon(
                  Icons.check,
                  size: 42,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Payment Successful',
                style: StyleManager.headingSmall(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Your order has been placed successfully.',
                style: StyleManager.textSmall(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
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
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Paid Amount', style: StyleManager.textSmall()),
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
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  context.go(RouteNames.home);
                },
                child: const Text('Continue Shopping'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  context.go(RouteNames.home);
                },
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
