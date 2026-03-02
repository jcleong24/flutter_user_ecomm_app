import 'package:flutter/material.dart';
import 'package:flutter_user_ecomm_app/core/theme/style_manager.dart';
import 'package:go_router/go_router.dart';
import '../core/routers/route_name.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List', style: StyleManager.headingSmall()),
      ),
      body: Center(
          child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("Product $index", style: StyleManager.textSmall()),
            onTap: () {
              context.push('${RouteNames.productDetails}/$index');
            },
          );
        },
      )),
    );
  }
}
