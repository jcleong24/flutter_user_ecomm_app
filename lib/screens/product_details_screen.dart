import 'package:flutter/material.dart';
import '../core/theme/style_manager.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details $productId',
            style: StyleManager.headingSmall()),
      ),
      body: Center(
        child: Text('Product Details: $productId',
            style: StyleManager.textSmall()),
      ),
    );
  }
}
