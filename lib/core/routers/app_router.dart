import 'package:flutter/material.dart';
import 'package:flutter_user_ecomm_app/core/routers/route_name.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/product_details_screen.dart';
import '../../presentation/cart/cart_screen.dart';
import '../../presentation/checkout_screen.dart';
import '../../presentation/home_screen.dart';
import '../../presentation/payment_screen.dart';
// import '../../screens/splash_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.home,
    routes: [
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const ProductListScreen(),
      ),
      GoRoute(
        path: '${RouteNames.productDetails}/:id',
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return ProductDetailsScreen(productId: productId);
        },
      ),
      GoRoute(
        path: RouteNames.cart,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: RouteNames.checkout,
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: RouteNames.payment,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;

          final orderId = data?['orderId'] as String?;
          final amountRaw = data?['amount'];

          if (orderId == null || amountRaw == null) {
            // fallback UI so it doesn't crash
            return const Scaffold(
              body: Center(
                child: Text('Missing orderId/amount'),
              ),
            );
          }
          return PaymentScreen(
            orderId: orderId,
            amount: (amountRaw as num).toDouble(),
          );
        },
      ),
    ],
  );
}
