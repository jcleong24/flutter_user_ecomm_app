import 'package:flutter_user_ecomm_app/core/routers/route_name.dart';
import 'package:go_router/go_router.dart';
import '../../screens/product_details_screen.dart';
import '../../screens/cart_screen.dart';
import '../../screens/checkout_screen.dart';
import '../../screens/home_screen.dart';
import '../../screens/payment_screen.dart';
import '../../screens/product_details_screen.dart';
// import '../../screens/splash_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.productDetails,
    routes: [
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const ProductListScreen(),
      ),
      GoRoute(
        path: RouteNames.productDetails,
        builder: (context, state) => const ProductDetailsScreen(),
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
        builder: (context, state) => const PaymentScreen(),
      ),
    ],
  );
}
