import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_user_ecomm_app/core/theme/style_manager.dart';
import 'package:flutter_user_ecomm_app/domain/bloc/product/product_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/routers/route_name.dart';
import '../domain/bloc/product/product_event.dart';
import '../domain/bloc/product/product_state.dart';
import 'cart/widgets/cart_icon_button.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Product List', style: StyleManager.headingSmall()),
          actions: const [
            CartIconButton(),
          ]),
      body: BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
        switch (state.status) {
          case ProductStatus.onLoading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ProductStatus.onLoaded:
            return ListView.separated(
              itemCount: state.products.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final p = state.products[index];
                return ListTile(
                  title: Text(p.name),
                  subtitle: Text('RM ${p.price.toStringAsFixed(2)}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.push('${RouteNames.productDetails}/${p.id}');
                  },
                );
              },
            );
          case ProductStatus.error:
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.errorMessage ?? 'Something went wrong'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context
                        .read<ProductBloc>()
                        .add(const ProductRequested()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          case ProductStatus.initial:
          default:
            return const SizedBox.shrink();
        }
      }),
    );
  }
}
