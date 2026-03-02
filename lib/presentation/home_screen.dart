import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_user_ecomm_app/bloc/product_event.dart';
import 'package:flutter_user_ecomm_app/core/theme/style_manager.dart';
import 'package:go_router/go_router.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_state.dart';
import '../core/routers/route_name.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List', style: StyleManager.headingSmall()),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ProductBloc>().add(const ProductRefreshed());
            },
          ),
        ],
      ),
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
