import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_user_ecomm_app/data/repositories/mock_product_repository.dart';
import 'package:flutter_user_ecomm_app/data/repositories/product_repository.dart';
import 'bloc/product_bloc.dart';
import 'core/routers/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProductRepository>(
            create: (context) => MockProductRepository())
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ProductBloc>(
            create: (context) => ProductBloc(
                productRepository: context.read<ProductRepository>()),
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
