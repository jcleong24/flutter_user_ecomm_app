import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_user_ecomm_app/core/theme/color_manager.dart';
import 'package:flutter_user_ecomm_app/domain/bloc/product/product_bloc.dart';
import 'package:flutter_user_ecomm_app/domain/bloc/product/product_event.dart';
import 'package:flutter_user_ecomm_app/domain/bloc/product/product_state.dart';
import 'package:flutter_user_ecomm_app/presentation/home/models/promo_item.dart';
import 'package:flutter_user_ecomm_app/presentation/home/widget/category_section.dart';
import 'package:flutter_user_ecomm_app/presentation/home/widget/home_header.dart';
import 'package:flutter_user_ecomm_app/presentation/home/widget/home_header_sub.dart';
import 'package:flutter_user_ecomm_app/presentation/home/widget/home_search_bar.dart';
import 'package:flutter_user_ecomm_app/presentation/home/widget/promo_auto_slider.dart';
import 'package:flutter_user_ecomm_app/presentation/response_page_padding.dart';
import 'package:go_router/go_router.dart';

import '../../core/routers/route_name.dart';
import 'models/category_card_data.dart';
import 'widget/trending_section.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  static const List<CategoryCardData> _categories = [
    CategoryCardData(
      title: 'Fruits',
      icon: Icons.apple_outlined,
    ),
    CategoryCardData(
      title: 'Vegetables',
      icon: Icons.eco_outlined,
    ),
    CategoryCardData(
      title: 'Drinks',
      icon: Icons.local_drink_outlined,
    ),
    CategoryCardData(
      title: 'Snacks',
      icon: Icons.cookie_outlined,
    ),
  ];

  static const List<PromoItem> _promoItems = [
    PromoItem(
      title: 'Fresh Food Delivered',
      subtitle: 'Get your groceries in minutes',
      icon: Icons.local_grocery_store_outlined,
    ),
    PromoItem(
      title: 'Special Discount',
      subtitle: 'Up to 30% off selected items',
      icon: Icons.discount_outlined,
    ),
    PromoItem(
      title: 'Daily Essentials',
      subtitle: 'Everything you need in one place',
      icon: Icons.shopping_basket_outlined,
    ),
    PromoItem(
      title: 'Free Shipping',
      subtitle: 'On orders over \$50',
      icon: Icons.local_shipping_outlined,
    ),
    PromoItem(
      title: 'Order Pickup',
      subtitle: 'Get your order delivered to your doorstep',
      icon: Icons.local_airport_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          switch (state.status) {
            case ProductStatus.onLoading:
              return const Center(
                child: CircularProgressIndicator(),
              );

            case ProductStatus.onLoaded:
              return Container(
                decoration: BoxDecoration(
                  color: ColorManager.backgroundColorTransparent,
                ),
                child: SafeArea(
                  child: ResponsivePagePadding(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HomeHeader(
                          onCartPressed: () => context.push(RouteNames.cart),
                          onNotificationPressed: () =>
                              context.push(RouteNames.cart),
                        ),
                        const SizedBox(height: 16),
                        HomeSearchBar(
                          onTap: () => context.push(RouteNames.cart),
                          onSearchPressed: () => context.push(RouteNames.cart),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const PromoSlider(items: _promoItems),
                                const SizedBox(height: 13),
                                const HomeHeaderSub(title: 'Categories'),
                                const SizedBox(height: 16),
                                const CategorySection(
                                  categories: _categories,
                                ),
                                const SizedBox(height: 16),
                                const HomeHeaderSub(title: 'Trending Products'),
                                const SizedBox(height: 16),
                                TrendingSection(
                                  products: state.products,
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
