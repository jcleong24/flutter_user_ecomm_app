import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_user_ecomm_app/core/theme/color_manager.dart';

import 'package:flutter_user_ecomm_app/core/theme/style_manager.dart';
import 'package:flutter_user_ecomm_app/domain/bloc/product/product_bloc.dart';
import 'package:flutter_user_ecomm_app/presentation/home/widget/category_card.dart';
import 'package:flutter_user_ecomm_app/presentation/home/widget/category_section.dart';
import 'package:flutter_user_ecomm_app/presentation/response_page_padding.dart';
import 'package:go_router/go_router.dart';

import '../core/routers/route_name.dart';
import '../domain/bloc/product/product_event.dart';
import '../domain/bloc/product/product_state.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  Timer? _autoSlideTimer;
  int _currentPage = 0;

  final List<CategoryCardData> _categories = const [
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

  final List<Map<String, dynamic>> _promoItems = [
    {
      'title': 'Fresh Food Delivered',
      'subtitle': 'Get your groceries in minutes',
      'icon': Icons.local_grocery_store_outlined,
    },
    {
      'title': 'Special Discount',
      'subtitle': 'Up to 30% off selected items',
      'icon': Icons.discount_outlined,
    },
    {
      'title': 'Daily Essentials',
      'subtitle': 'Everything you need in one place',
      'icon': Icons.shopping_basket_outlined,
    },
    {
      'title': 'Free Shipping',
      'subtitle': 'On orders over \$50',
      'icon': Icons.local_shipping_outlined,
    },
    {
      'title': 'Order Pickup',
      'subtitle': 'Get your order delivered to your doorstep',
      'icon': Icons.local_airport_outlined,
    }
  ];

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();

    _autoSlideTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (!mounted || !_pageController.hasClients || _promoItems.isEmpty)
        return;

      final nextPage = (_currentPage + 1) % _promoItems.length;

      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  void _stopAutoSlide() {
    _autoSlideTimer?.cancel();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _stopAutoSlide();
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildPromoCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorManager.primary,
            ColorManager.primaryVariant,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: StyleManager.headingSmall().copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: StyleManager.button().copyWith(
                    color: ColorManager.whiteTransparent,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: ColorManager.borderTransparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    'Shop Now',
                    style: StyleManager.button().copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Positioned(
            top: 16,
            right: 16,
            child: Material(
              color: Colors.transparent,
              child: Ink(
                // width: 60,
                decoration: const ShapeDecoration(
                  color: ColorManager.borderTransparent,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  iconSize: 35,
                  icon: const Icon(Icons.shopping_bag_outlined),
                  color: ColorManager.white,
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(int index) {
    final isActive = _currentPage == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: isActive ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? ColorManager.primary
            : ColorManager.border.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
        switch (state.status) {
          case ProductStatus.onLoading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ProductStatus.onLoaded:
            // return ListView.separated(
            //   itemCount: state.products.length,
            //   separatorBuilder: (_, __) => const Divider(height: 1),
            //   itemBuilder: (context, index) {
            //     final p = state.products[index];
            return Container(
                decoration: BoxDecoration(
                    color: ColorManager.backgroundColor.withOpacity(0.1)),
                child: SafeArea(
                  child: ResponsivePagePadding(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                'Find the best products',
                                style: StyleManager.headingSemiMedium(),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Flexible(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Ink(
                                    // width: 60,
                                    decoration: const ShapeDecoration(
                                      color: ColorManager.border,
                                      shape: CircleBorder(),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                          Icons.shopping_bag_outlined),
                                      color: ColorManager.primary,
                                      onPressed: () {},
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Ink(
                                    // width: 60,
                                    decoration: const ShapeDecoration(
                                      color: ColorManager.border,
                                      shape: CircleBorder(),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                          Icons.notifications_outlined),
                                      color: ColorManager.primary,
                                      onPressed: () =>
                                          context.push(RouteNames.cart),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                height: 56,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: ColorManager.surface,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              16, 0, 0, 0),
                                      child: IconButton(
                                        icon: const Icon(Icons.search),
                                        color: ColorManager.primary,
                                        onPressed: () =>
                                            context.push(RouteNames.cart),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              16, 0, 0, 0),
                                      child: Text(
                                        'Search',
                                        style: StyleManager.caption(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 180,
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (notification) {
                              if (notification is ScrollStartNotification) {
                                _stopAutoSlide();
                              } else if (notification
                                  is ScrollEndNotification) {
                                _startAutoSlide();
                              }
                              return false;
                            },
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: _promoItems.length,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentPage = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                final item = _promoItems[index];

                                return AnimatedBuilder(
                                  animation: _pageController,
                                  builder: (context, child) {
                                    double scale = 1.0;

                                    if (_pageController.hasClients &&
                                        _pageController
                                            .position.haveDimensions) {
                                      final page = _pageController.page ??
                                          _currentPage.toDouble();
                                      final diff = (page - index).abs();
                                      scale =
                                          (1 - (diff * 0.06)).clamp(0.94, 1.0);
                                    }

                                    return Transform.scale(
                                      scale: scale,
                                      child: child,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    child: _buildPromoCard(
                                      title: item['title'] as String,
                                      subtitle: item['subtitle'] as String,
                                      icon: item['icon'] as IconData,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Expanded(
                        //   child: ListView.builder(
                        //     itemCount: state.products.length,
                        //     itemBuilder: (context, index) {
                        //       final p = state.products[index];
                        //       return ListTile(
                        //         title: Text(p.name),
                        //         subtitle: Text('RM ${p.price.toStringAsFixed(2)}'),
                        //         trailing: const Icon(Icons.chevron_right),
                        //         onTap: () {
                        //           context
                        //               .push('${RouteNames.productDetails}/${p.id}');
                        //         },
                        //       );
                        //     },
                        //   ),
                        // ),
                        // ListTile(
                        //   title: Text(p.name),
                        //   subtitle: Text('RM ${p.price.toStringAsFixed(2)}'),
                        //   trailing: const Icon(Icons.chevron_right),
                        //   onTap: () {
                        //     context.push('${RouteNames.productDetails}/${p.id}');
                        //   },
                        // );

                        CategorySection(
                          categories: _categories,
                        ),
                      ],
                    ),
                  ),
                ));

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
