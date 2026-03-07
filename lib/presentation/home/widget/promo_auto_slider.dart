import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_user_ecomm_app/presentation/home/models/promo_item.dart';
import 'package:flutter_user_ecomm_app/presentation/home/widget/promo_card.dart';
import 'package:flutter_user_ecomm_app/presentation/home/widget/promo_indicator.dart';

class PromoSlider extends StatefulWidget {
  final List<PromoItem> items;

  const PromoSlider({
    super.key,
    required this.items,
  });

  @override
  State<PromoSlider> createState() => _PromoSliderState();
}

class _PromoSliderState extends State<PromoSlider> {
  late final PageController _pageController;
  Timer? _autoSlideTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();

    _autoSlideTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (!mounted || !_pageController.hasClients || widget.items.isEmpty) {
        return;
      }

      final nextPage = (_currentPage + 1) % widget.items.length;

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
    _stopAutoSlide();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollStartNotification) {
                _stopAutoSlide();
              } else if (notification is ScrollEndNotification) {
                _startAutoSlide();
              }
              return false;
            },
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.items.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final item = widget.items[index];

                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double scale = 1.0;

                    if (_pageController.hasClients &&
                        _pageController.position.haveDimensions) {
                      final page =
                          _pageController.page ?? _currentPage.toDouble();
                      final diff = (page - index).abs();
                      scale = (1 - (diff * 0.06)).clamp(0.94, 1.0);
                    }

                    return Transform.scale(
                      scale: scale,
                      child: child,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: PromoCard(
                      title: item.title,
                      subtitle: item.subtitle,
                      icon: item.icon,
                      onShopNowPressed: () {},
                      onIconPressed: () {},
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.items.length,
            (index) => PromoIndicator(
              isActive: _currentPage == index,
            ),
          ),
        ),
      ],
    );
  }
}
