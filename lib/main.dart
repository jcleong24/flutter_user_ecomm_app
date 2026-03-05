import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_user_ecomm_app/data/repositories/payment_repository.dart';
import 'package:flutter_user_ecomm_app/data/services/stripe_payment_service.dart';
import 'package:flutter_user_ecomm_app/domain/bloc/order/order_bloc.dart';
import 'core/routers/app_router.dart';
import 'core/theme/app_theme.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repositories/order_repository.dart';
import 'domain/bloc/cart/cart_bloc.dart';
import 'domain/bloc/payment/payment_bloc.dart';
import 'domain/bloc/product/product_bloc.dart';
import 'domain/bloc/product/product_event.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_user_ecomm_app/data/repositories/product_repository.dart';
import 'package:flutter_user_ecomm_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey =
      "pk_test_51T4F8QDcytiORkzmPs4zFbbuLKIgOvRYhzkN9NcgXbuF1FNvJrISE27gcQpPOAtA2Era5UUjgVSVrUOsk1hvlF5V00ssbx3bZu"; // your Stripe test publishable key
  await Stripe.instance.applySettings();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProductRepository>(
          create: (context) =>
              FirebaseProductRepository(FirebaseFirestore.instance),
        ),
        RepositoryProvider<OrderRepository>(
          create: (context) =>
              FirebaseOrderRepository(FirebaseFirestore.instance),
        ),
        RepositoryProvider<PaymentRepository>(
          create: (context) =>
              FirebasePaymentRepository(FirebaseFirestore.instance),
        ),
        RepositoryProvider<StripePaymentService>(
          create: (_) => StripePaymentService(FirebaseFunctions.instance),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ProductBloc>(
            create: (context) => ProductBloc(
              productRepository: context.read<ProductRepository>(),
            )..add(const ProductRequested()),
          ),
          BlocProvider<CartBloc>(
            create: (context) => CartBloc(),
          ),
          BlocProvider<OrderBloc>(
            create: (context) => OrderBloc(
              orderRepository: context.read<OrderRepository>(),
            ),
          ),
          BlocProvider<PaymentBloc>(
            create: (context) => PaymentBloc(
              paymentRepository: context.read<PaymentRepository>(),
              orderRepository: context.read<OrderRepository>(),
              stripePaymentService: context.read<StripePaymentService>(),
            ),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      theme: AppTheme.light(),
      debugShowCheckedModeBanner: true,
    );
  }
}
